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
      .joins(:membership)
      .order('membership_weeks.points DESC, memberships.position ASC')
      .includes(picks: [:picked_team, match: [:winning_team]], membership: [:account, :group])
  end

  def self.update_member_positions
    Group.all.each do |group|
      group.memberships
        .select('*, (select sum(points) from membership_weeks where membership_id = memberships.id) as new_total')
        .order('new_total desc')
        .each_with_index do |membership, index|
          membership.update position: index + 1, total: membership.new_total
        end
    end
  end

  private

  def generate_group_weeks
    tournament.weeks.each do |week|
      group_weeks.create week: week
    end
  end
end
