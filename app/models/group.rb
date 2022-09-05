class Group < ApplicationRecord
  belongs_to :tournament
  has_many :requests, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships
  has_many :membership_weeks, through: :memberships
  has_many :winners, through: :membership_weeks
  has_many :group_weeks, dependent: :destroy
  validates_presence_of :name
  after_create :generate_group_weeks
  scope :active, -> { where finished: false }
  scope :finished, -> { where finished: true }
  validates :name, uniqueness: { scope: :tournament_id }


  def daily_update
    week = tournament.current_week
    week.fetch_match_results
    week.update_picks
    update_member_positions
    AdminMailer.update_success(week, self).deliver_now
  end


  def membership_weeks_of(week)
    membership_weeks
      .where(week: week, memberships: { suspended: false })
      .joins(:membership)
      .order('membership_weeks.points DESC, memberships.position ASC')
      .includes(picks: [:picked_team, match: [:winning_team, :home_team, :visit_team]], membership: [:account, :group])
  end

  def membership_weeks_forgetting(week)      
    MembershipWeek.where(id: forgotten_members(week).pluck(:id))
      .joins(:membership)
      .order('membership_weeks.points DESC, memberships.position ASC')
      .includes(picks: [:picked_team, match: [:winning_team]], membership: [:account, :group])
  end

  def notify_missing_picks(week)
    forgotten_members(week).each do |membership_week|
      MembershipMailer.with(membership_week: membership_week).picks_reminder.deliver_later
    end
  end

  def update_member_positions
    memberships.where(suspended: false)
      .select('*, (select sum(points) from membership_weeks where membership_id = memberships.id) as new_total')
      .order('new_total desc')
      .each_with_index do |membership, index|
        membership.update position: index + 1, total: membership.new_total
      end
  end

  private

  def generate_group_weeks
    tournament.weeks.each do |week|
      group_weeks.create week: week
    end
  end

  def forgotten_members(week)
    @forgotten_members ||= membership_weeks.includes(:membership).where(week: week, membership: { suspended: false }).select do |membership_week|
      membership_week.picks.forgotten.count > 0
    end
  end
end
