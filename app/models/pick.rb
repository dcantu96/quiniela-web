class Pick < ApplicationRecord
  include Filterable
  belongs_to :match
  belongs_to :membership_week
  belongs_to :picked_team, class_name: 'Team', inverse_of: :picks, optional: true
  scope :filter_by_week_number, -> (group_week) { where group_week: group_week }
  validate :check_if_correct, if: :picked_team_id_changed?

  def viewable?
    Time.current > match.show_time
  end

  def not_viewable?
    Time.current < match.show_time
  end

  def updatable?
    Time.current < match.show_time - 30.minutes
  end

  private

  def check_if_correct
    if match.winning_team
      self.correct = picked_team == match.winning_team
      new_points = match.premium ? 2 : 1
      if correct
        membership_week.update points: membership_week.points + new_points 
      else
        membership_week.update points: membership_week.points - new_points
      end
    end
  end
end
