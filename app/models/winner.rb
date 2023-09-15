class Winner < ApplicationRecord
  belongs_to :membership_week
  validates_uniqueness_of :membership_week
end
