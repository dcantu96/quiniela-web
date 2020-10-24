class Match < ApplicationRecord
  belongs_to :week
  belongs_to :visit_team, class_name: 'Team', inverse_of: :visit_matches
  belongs_to :home_team, class_name: 'Team', inverse_of: :home_matches
  belongs_to :winning_team, class_name: 'Team', inverse_of: :wins, optional: true
  has_many :picks, dependent: :destroy
  after_create :generate_picks
  before_save :set_new_membership_week_to_picks, if: :will_save_change_to_week_id?
  after_save :update_week_match_order, if: :will_save_change_to_start_time?
  before_save :update_picked_team, if: :will_save_change_to_home_team_id?
  before_save :update_picked_team, if: :will_save_change_to_visit_team_id?

  def update_picks
    picks.where(picked_team: winning_team).find_each { |p| p.update correct: true }
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
    Time.current > start_time
  end

  def fetch_result
    # For this fetch to work team short names must be identical to ESPN's
    doc = Nokogiri::HTML(URI.open("https://www.espn.com/nfl/schedule/_/week/#{week.number}"))
    td = doc.at("td a[name='&lpos=nfl:schedule:score']:contains('#{home_team.short_name}')")
    return false if td.nil?
    
    score_text = td.children.text
    scores = score_text.split(',')
    scores.each do |score|
      team_score = score.split(' ')
      self.update home_team_score: team_score.second if team_score.first == home_team.short_name
      self.update visit_team_score: team_score.second if team_score.first == visit_team.short_name
    end
    if home_team_score.present?
      if home_team_score == visit_team_score
        self.update tie: true
      else
        if home_team_score > visit_team_score
          self.update winning_team: home_team
        else
          self.update winning_team: visit_team
        end
      end
    end
    true
  end

  private

  def update_week_match_order
    week.matches.order(start_time: :asc).each_with_index do |match, i|
      match.update order: i
    end
  end

  def generate_picks
    week.membership_weeks.each do |membership_week|
      picks.create membership_week: membership_week
    end
  end
end
