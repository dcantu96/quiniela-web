class MembershipWeek < ApplicationRecord
  belongs_to :membership
  belongs_to :week
  has_many :picks, dependent: :destroy
  has_many :winners, dependent: :destroy
  validates :membership, uniqueness: { scope: :week }
  validate :uniqueness_of_membership
  scope :current, -> (current_week) { where(week: current_week).limit(1) }

  def uniqueness_of_membership
    maybe_duplicate_weeks = membership.membership_weeks.joins(:week).where(week: { number: week.number })
    if maybe_duplicate_weeks.count > 1
      errors.add(:match, "Invalid. Week #{week.number} already exists in this membership")
    end
  end

  def untie_pick(untie_match)
    picks.find_by match: untie_match
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "membership_id", "points", "updated_at", "week_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["membership", "picks", "week", "winners"]
  end
end
