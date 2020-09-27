class Pick < ApplicationRecord
  include Filterable
  belongs_to :match
  belongs_to :membership_week
  belongs_to :picked_team, class_name: 'Team', inverse_of: :picks, optional: true
  scope :filter_by_week_number, -> (group_week) { where group_week: group_week }
  validate :check_if_correct, if: :picked_team_id_changed?

  def viewable?
    match.started?
  end

  def not_viewable?
    !match.started?
  end

  def updatable?
    !match.started?
  end

  private

  def check_if_correct
    if match.winning_team
      pick_incorrect_previously = !correct
      pick_correct_previously = correct
      self.correct = picked_team == match.winning_team
      new_points = match.premium ? 2 : 1
      if correct && pick_incorrect_previously
        membership_week.update points: membership_week.points + new_points 
      elsif !correct && pick_correct_previously
        membership_week.update points: membership_week.points - new_points
      end
    end
  end
end
