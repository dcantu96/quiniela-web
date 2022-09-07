class Request < ApplicationRecord
  belongs_to :group
  belongs_to :account
  scope :pending, -> { where denied: false }
  scope :denied, -> { where denied: true }
  validates_uniqueness_of :group, scope: [:account]
  validate :membership_not_present

  def membership_not_present
    if account.memberships.where(group: group).present?
      errors.add(:request, "already exists")
    end
  end
end
