class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :group
  has_many :membership_weeks, dependent: :destroy
  has_many :picks, through: :membership_weeks
  after_create :generate_weeks_and_picks
  validates :account, uniqueness: { scope: :group }
  scope :active, -> { includes(:group).where(group: { finished: false }, suspended: false) }
  scope :suspended, -> { where(suspended: true) }
  scope :finished, -> { includes(:group).where group: { finished: true } }

  def current_week_picks
    return nil if current_membership_week.nil?
    current_membership_week.picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).order('matches.order')
  end

  def picks_of(week)
    membership_week = membership_weeks.find_by(week: week)
    return nil if membership_week.nil?
    membership_week.picks.includes(:picked_team, match: [:home_team, :visit_team, :winning_team]).order('matches.order')
  end

  def current_membership_week
    membership_weeks.current(group.tournament.current_week).first
  end

  private

  # This action will create weeks and picks
  def generate_weeks_and_picks
    MembershipInitializerJob.perform_later(id)
  end
end