class Week < ApplicationRecord
  belongs_to :tournament
  has_many :group_weeks
  has_many :membership_weeks
  has_many :groups, through: :group_weeks
  has_many :matches
  after_create :generate_group_weeks
  after_save :update_picks, if: :will_save_change_to_finished?

  def start_time
    first_match.start_time
  end

  def first_match
    matches.order(start_time: :desc).limit(1).first
  end

  def matches_settled?
    matches.where('(winning_team_id is null AND tie = false) or (winning_team_id is not null AND tie = true)').empty?
  end

  def next_week
    Week.find_by number: number + 1, tournament: tournament
  end

  def previous_week
    Week.find_by number: number - 1, tournament: tournament
  end


  def untie_match
    matches.find_by untie: true
  end

  def update_picks
    matches.each do |match|
      match.update_picks if match.winning_team.present?
    end
  end

  def fetch_match_results
    matches.each do |match|
      match.fetch_result
    end
  end

  def reset_points(group)
    membership_weeks.where(group: group).each do |mw|
      mw.picks.each { |p| p.update correct: false }
      mw.update points: 0
    end
  end

  private

  def generate_group_weeks
    tournament.groups.each do |group|
      group_weeks.create group: group
    end
  end
end
