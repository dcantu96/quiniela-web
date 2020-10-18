class Tournament < ApplicationRecord
  belongs_to :sport
  has_many :weeks
  has_many :matches, through: :weeks
  has_many :groups

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
        if !week.finished
          week.matches.order(start_time: :asc).each_with_index do |match, index|
            match.update order: index
          end
        end
      end
    end
  end
end
