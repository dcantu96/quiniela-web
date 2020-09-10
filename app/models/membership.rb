class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :group
  has_many :picks
  has_many :membership_weeks, dependent: :destroy
  after_create :generate_weeks
  validates :account, uniqueness: { scope: :group }

  def current_week_picks
    membership_weeks.find_by(week: group.tournament.current_week).picks
  end

  private

  def generate_weeks
    group.tournament.weeks.includes(:matches).each do |week|
      membership_weeks.create group: group, week: week
    end
  end
end