class GroupWeek < ApplicationRecord
  belongs_to :group
  belongs_to :week
  belongs_to :winner, class_name: 'Account', inverse_of: :week_wins, optional: true
  has_many :picks
end
