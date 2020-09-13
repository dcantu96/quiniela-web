class Account < ApplicationRecord
  belongs_to :user
  has_many :week_wins, class_name: 'GroupWeek', foreign_key: :winner_id, inverse_of: :winner
  has_many :memberships
  has_many :groups, through: :memberships
  has_many :requests
  validates_uniqueness_of :username
  validates_presence_of :username
  validates :username,
    length: {in: 3..10, message: "should be 3-10 characters long" },
    format: { with: /\A[a-z0-9_]{3,10}\z/, message: "contains invalid characters" }
  accepts_nested_attributes_for :requests
end
