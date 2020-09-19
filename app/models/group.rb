class Group < ApplicationRecord
  belongs_to :tournament
  has_many :requests
  has_many :memberships
  has_many :membership_weeks
  has_many :winners, through: :membership_weeks
  has_many :accounts, through: :memberships
  validates_uniqueness_of :name
  validates_presence_of :name
  after_create :generate_group_weeks

  def membership_weeks_of(week)
    membership_weeks
      .where(week: week)
      .order(points: :desc)
      .includes(picks: [:picked_team, match: [:winning_team]], membership: [:account, :group])
  end

  private

  def generate_group_weeks
    tournament.weeks.each do |week|
      group_weeks.create week: week
    end
  end
end
