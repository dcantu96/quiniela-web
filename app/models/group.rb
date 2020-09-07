class Group < ApplicationRecord
  belongs_to :tournament
  has_many :group_weeks
  has_many :weeks, through: :group_weeks
  has_many :requests
  has_many :memberships
  has_many :accounts, through: :memberships
  validates_uniqueness_of :name
  validates_presence_of :name
  after_create :generate_group_weeks

  private

  def generate_group_weeks
    tournament.weeks.each do |week|
      group_weeks.create week: week
    end
  end
end
