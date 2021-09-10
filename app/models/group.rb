class Group < ApplicationRecord
  belongs_to :tournament
  has_many :requests
  has_many :memberships
  has_many :membership_weeks
  has_many :group_weeks
  has_many :winners, through: :membership_weeks
  has_many :accounts, through: :memberships
  validates_uniqueness_of :name
  validates_presence_of :name
  after_create :generate_group_weeks
  scope :active, -> { where finished: false }


  def daily_update
    week = tournament.current_week
    week.fetch_match_results
    week.update_picks
    update_member_positions
    AdminMailer.update_success(week, self).deliver_now
  end


  def membership_weeks_of(week)
    membership_weeks
      .where(week: week)
      .joins(:membership)
      .order('membership_weeks.points DESC, memberships.position ASC')
      .limit(40)
      .includes(picks: [:picked_team, match: [:winning_team, :home_team, :visit_team]], membership: [:account, :group])
  end

  def membership_weeks_forgetting(week)
    forgotten_members = membership_weeks.where(week: week).select do |membership_week|
      membership_week.picks.forgotten.count > 0
    end
      
      MembershipWeek.where(id: forgotten_members.pluck(:id)).joins(:membership)
      .order('membership_weeks.points DESC, memberships.position ASC')
      .includes(picks: [:picked_team, match: [:winning_team]], membership: [:account, :group])
  end

  def update_member_positions
    memberships
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
end
