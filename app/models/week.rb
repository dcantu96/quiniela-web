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

  def next_week
    Week.find_by number: number + 1, tournament: tournament
  end

  def previous_week
    Week.find_by number: number - 1, tournament: tournament
  end


  def untie_match
    matches.find_by untie: true
  end

  private

  def generate_group_weeks
    tournament.groups.each do |group|
      group_weeks.create group: group
    end
  end

  def update_picks
    group_weeks.each do |group_week|
      group_week.picks.each do |pick| 
        pick.update correct: pick.picked_team == pick.match.winning_team
      end
    end
  end
end
