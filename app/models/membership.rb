class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :group
  has_many :picks
  after_create :generate_picks

  def current_week_picks
    picks.where group_week: GroupWeek.find_by(group: group,
                                              week: group.tournament.current_week)
  end

  private

  def generate_picks
    group.group_weeks.each do |group_week|
      group_week.week.matches.each do |match|
        picks.create match: match, group_week: group_week
      end
    end
  end
end
