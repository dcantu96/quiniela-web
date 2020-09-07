class Match < ApplicationRecord
  belongs_to :week
  belongs_to :visit_team, class_name: 'Team', inverse_of: :visit_matches
  belongs_to :home_team, class_name: 'Team', inverse_of: :home_matches
  belongs_to :winning_team, class_name: 'Team', inverse_of: :wins, optional: true
  has_many :picks, dependent: :destroy
  after_create :generate_picks
  after_save :update_picks, if: :will_save_change_to_winning_team_id?

  private

  def generate_picks
    week.group_weeks.each do |group_week|
      group_week.group.memberships.each do |membership|
        picks.create group_week: group_week, membership: membership
      end
    end
  end

  def update_picks
    picks.each do |pick|
      pick.update correct: pick.picked_team == winning_team
    end
  end
end
