
class Tournament < ApplicationRecord
  belongs_to :sport
  has_many :weeks
  has_many :matches, through: :weeks
  has_many :groups
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

  def generate_week_matches
    require 'open-uri'
    valid_week_url = true
    iterable_week = 1
    while valid_week_url do
      begin
        doc = Nokogiri::HTML(URI.open("https://www.espn.com/nfl/schedule/_/week/#{iterable_week}/year/#{year}/seasontype/2", redirect: :true))

        new_week = weeks.find_or_create_by number: iterable_week
        new_week.generate_matches(doc)
        iterable_week = iterable_week + 1

      rescue
        valid_week_url = false
      end
    end
  end
end
