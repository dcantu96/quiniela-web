class Match < ApplicationRecord
  belongs_to :week
  belongs_to :visit_team, class_name: 'Team', inverse_of: :visit_matches
  belongs_to :home_team, class_name: 'Team', inverse_of: :home_matches
  belongs_to :winning_team, class_name: 'Team', inverse_of: :wins, optional: true
  has_many :picks, dependent: :destroy
  after_create :generate_picks
  before_save :set_new_membership_week_to_picks, if: :will_save_change_to_week_id?
  before_save :update_picked_team, if: :will_save_change_to_home_team_id?
  before_save :update_picked_team, if: :will_save_change_to_visit_team_id?
  validates_uniqueness_of :week, scope: [:visit_team, :home_team]
  validates_presence_of :week
  validate :uniqueness_of_matches, :valid_match_winner

  def uniqueness_of_matches
    return if week.nil?
    matches_to_check = week.matches.where.not(id: self.id)
    invalid_matches = matches_to_check.where(visit_team: visit_team)
      .or(matches_to_check.where(home_team: visit_team))
      .or(matches_to_check.where(visit_team: home_team))
      .or(matches_to_check.where(home_team: home_team))
    #  There cannot be another match in the same week with one of these teams
    if invalid_matches.present?
      errors.add(:match, "Invalid. Week #{week.number} already has a match with #{visit_team.name} and/or #{home_team.name}")
    end
  end

  def valid_match_winner
    return if winning_team.nil?
    if winning_team.present? && winning_team != home_team && winning_team != visit_team
      errors.add(:match, "Invalid winning team #{winning_team.name}. Team must be either #{visit_team.name} and/or #{home_team.name}")
    end
  end


  def update_picks
    picks.where(picked_team: winning_team).update_all correct: true
  end

  def update_picked_team
    if !settled?
      picks.joins(:match)
        .where('picked_team_id is not null and picked_team_id != matches.visit_team_id and picked_team_id != matches.home_team_id')
        .find_each { |p| p.update picked_team: nil }
    end
  end

  def set_new_membership_week_to_picks
    picks.each do |pick|
      if week != pick.membership_week.week
        new_membership_week = pick.membership_week.membership.membership_weeks.find_by week: week
        pick.update membership_week: new_membership_week
      end
    end
  end

  def settled?
    winning_team.present? || tie
  end

  def started?
    start_time ? Time.current > start_time : false
  end

  # This functions will generate picks once a match is created
  # The picks this function creates are any picks that are duplicate
  def generate_picks
    week.tournament.memberships.each do |membership|
      membership_week = MembershipWeek.find_or_create_by membership: membership, week: week
      Pick.find_or_create_by membership_week: membership_week, match: self
    end
  end
end
