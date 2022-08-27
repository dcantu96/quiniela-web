class Request < ApplicationRecord
  belongs_to :group
  belongs_to :account
  scope :pending, -> { where denied: false }
  scope :denied, -> { where denied: true }
end
