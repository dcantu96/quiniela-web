class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :group
  has_many :membership_weeks, dependent: :destroy
  has_many :picks, through: :membership_weeks
  after_create :generate_weeks
  validates :account, uniqueness: { scope: :group }
  scope :active, -> { joins(:group).where(group: { finished: false }, suspended: false) }
  scope :finished, -> { joins(:group).where group: { finished: true } }

  def current_week_picks
    current_membership_week.picks
  end

  def current_membership_week
    membership_weeks.current(group.tournament.current_week).first
  end

  private

  def generate_weeks
    group.tournament.weeks.each do |week|
      membership_weeks.create group: group, week: week
    end
  end
end