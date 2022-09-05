class Pick < ApplicationRecord
  include Filterable
  belongs_to :match
  belongs_to :membership_week
  belongs_to :picked_team, class_name: 'Team', inverse_of: :picks, optional: true
  scope :viewable, -> { joins(:match).where('matches.start_time < ?', Time.current) }
  scope :forgotten, -> { joins(:match).where("picks.picked_team_id IS NULL AND matches.winning_team_id IS NULL AND matches.tie = false AND (:time_limit > matches.start_time)", time_limit: Time.current + 6.hours) }
  before_save :check_if_correct, if: :will_save_change_to_picked_team_id?
  before_save :update_points, if: :will_save_change_to_correct?
  validate :membership_week_must_be_same_as_match_week, :picked_team_must_be_in_match
  validates_uniqueness_of :match, scope: [:membership_week]
  

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

  def membership_week_must_be_same_as_match_week
    errors.add(:match, "Must have the same week as the membership week") unless match.week == membership_week.week
  end

  def picked_team_must_be_in_match
    if picked_team.present? && match.home_team != picked_team && match.visit_team != picked_team
      errors.add(:match, "Picked team must be from match")
    end
  end

  def update_points
    new_points = match.premium ? 2 : 1
    if correct
      membership_week.update points: membership_week.points + new_points 
    else
      membership_week.update points: membership_week.points - new_points
    end
  end

  def check_if_correct
    if match.winning_team
      self.correct = picked_team == match.winning_team
    end
  end
end
