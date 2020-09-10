class Pick < ApplicationRecord
  include Filterable
  belongs_to :match
  belongs_to :membership_week
  belongs_to :picked_team, class_name: 'Team', inverse_of: :picks, optional: true
  scope :filter_by_week_number, -> (group_week) { where group_week: group_week }

  def viewable?
    Time.current > match.show_time
  end

  def not_viewable?
    Time.current < match.show_time
  end
end
