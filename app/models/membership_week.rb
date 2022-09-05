class MembershipWeek < ApplicationRecord
  belongs_to :membership
  belongs_to :week
  has_many :picks, dependent: :destroy
  has_many :winners, dependent: :destroy
  validates :membership, uniqueness: { scope: :week }
  scope :current, -> (current_week) { where(week: current_week).limit(1) }

  def untie_pick(untie_match)
    picks.find_by match: untie_match
  end
end
