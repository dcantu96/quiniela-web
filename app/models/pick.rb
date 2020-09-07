class Pick < ApplicationRecord
  belongs_to :membership
  belongs_to :match
  belongs_to :group_week
  belongs_to :picked_team, class_name: 'Team', inverse_of: :picks, optional: true
end
