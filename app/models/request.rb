class Request < ApplicationRecord
  belongs_to :group
  belongs_to :account
  scope :pending, -> { where denied: false }
end
