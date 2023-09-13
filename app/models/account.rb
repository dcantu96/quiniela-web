class Account < ApplicationRecord
  belongs_to :user
  has_many :week_wins, class_name: 'GroupWeek', foreign_key: :winner_id, inverse_of: :winner
  has_many :memberships
  has_many :groups, through: :memberships
  has_many :requests
  validates_uniqueness_of :username, case_sensitive: false
  validates_presence_of :username
  scope :with_group, -> (group_id) { includes(:memberships).where(memberships: { group_id: group_id }) }
  scope :not_in_group, -> (group_id) { includes(:memberships).where.not(memberships: { group_id: group_id }) }
  scope :active, -> { left_outer_joins(:memberships, :requests).where.not(memberships: { id: nil }) }
  scope :inactive, -> { left_outer_joins(:memberships, :requests).where(memberships: { id: nil }).where(requests: { id: nil }) }
  validates :username,
    length: { in: 3..12, message: "should be 3-12 characters long" },
    format: { with: /\A[a-zA-Z]+_?[a-zA-Z0-9]+\z/, message: "contains invalid characters. Should always start with letters" }
  accepts_nested_attributes_for :requests


  def account_detail
    "#{username} - #{user.email}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "updated_at", "user_id", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["groups", "memberships", "requests", "user", "week_wins"]
  end
end
