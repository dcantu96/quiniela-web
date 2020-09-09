class Match < ApplicationRecord
  belongs_to :week
  belongs_to :visit_team, class_name: 'Team', inverse_of: :visit_matches
  belongs_to :home_team, class_name: 'Team', inverse_of: :home_matches
  belongs_to :winning_team, class_name: 'Team', inverse_of: :wins, optional: true
  has_many :picks, dependent: :destroy
  after_create :generate_picks
  before_create :set_show_time
  after_save :update_picks, if: :will_save_change_to_winning_team_id?

  private

  def generate_picks
    week.membership_weeks.each do |membership_week|
      picks.create membership_week: membership_week
    end
  end

  def update_picks
    picks.each do |pick|
      pick.update correct: pick.picked_team == winning_team
    end
  end

  def set_show_time
    self.show_time = start_time - 30.minutes if show_time.nil?
  end
end
