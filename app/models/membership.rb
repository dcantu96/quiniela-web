class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :group
  has_many :membership_weeks, dependent: :destroy
  has_many :picks, through: :membership_weeks
  after_create :generate_weeks
  validates :account, uniqueness: { scope: :group }
  scope :active, -> { includes(:group).where(group: { finished: false }, suspended: false) }
  scope :finished, -> { includes(:group).where group: { finished: true } }

  def current_week_picks
    current_membership_week.picks
  end

  def current_membership_week
    membership_weeks.current(group.tournament.current_week).first
  end

  private

  def generate_weeks
    maybe_delete_request = account.requests.find_by(group: group)
    if maybe_delete_request.present?
      maybe_delete_request.destroy
    end
    group.tournament.weeks.each do |week|
      membership_weeks.create group: group, week: week
    end
  end
end