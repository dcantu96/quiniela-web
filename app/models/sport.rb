class Sport < ApplicationRecord
  has_many :tournaments
  has_many :teams
  validates :name, uniqueness: true
end
