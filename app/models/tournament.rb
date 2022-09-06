
class Tournament < ApplicationRecord
  belongs_to :sport
  has_many :weeks, dependent: :destroy
  has_many :matches, through: :weeks
  has_many :groups, dependent: :destroy
  has_many :memberships, through: :groups
  validates :name, uniqueness: { scope: :year }
  validates :year, presence: true
  scope :valid, -> { where.not(year: nil) }

  def with_year
    name + " - " + year
  end

  def current_week
    @current_week ||= weeks.where(finished: false).order(number: :asc).limit(1).first
  end

  def current_week_matches
    @current_week_matches ||= current_week.matches
      .includes(:home_team, :visit_team, :winning_team)
      .order(order: :asc)
  end

  def self.update_week_order
    Tournament.all.each do |tournament|
      tournament.weeks.each do |week|
        week.matches.order(start_time: :asc).each_with_index do |match, index|
          match.update order: index
        end
      end
    end
  end

  def find_or_create_matches(default_week_number = nil)
    require 'open-uri'
    iterable_week = default_week_number || 1
    loop do
      doc = Nokogiri::HTML(URI.open("https://www.espn.com/nfl/schedule/_/week/#{iterable_week}/year/#{year}/seasontype/2", redirect: :true))
      empty_text = doc.css('.EmptyTable-caption.Table__Title').text
      tables = doc.css('div.ResponsiveTable')
      break if empty_text.include? 'No Data Available'
      break if tables.length == 0

      new_week = weeks.find_or_create_by number: iterable_week
      new_week.generate_matches(doc)
      break if default_week_number.present?

      iterable_week = iterable_week + 1
    end
  end
end
