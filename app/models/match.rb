class Match < ApplicationRecord
  belongs_to :week
  belongs_to :visit_team, class_name: 'Team', inverse_of: :visit_matches
  belongs_to :home_team, class_name: 'Team', inverse_of: :home_matches
  belongs_to :winning_team, class_name: 'Team', inverse_of: :wins, optional: true
  has_many :picks, dependent: :destroy
  after_create :generate_picks

  def update_picks
    picks.includes(:picked_team).each do |p|
      pick_incorrect_previously = !p.correct
      pick_correct_previously = p.correct
      p.update correct: p.picked_team == winning_team
      new_points = premium ? 2 : 1
      if p.correct && pick_incorrect_previously
        p.membership_week.update points: p.membership_week.points + new_points
      elsif !p.correct && pick_correct_previously
        p.membership_week.update points: p.membership_week.points - new_points
      end
    end
    Group.update_member_positions
  end

  def settled?
    winning_team.present? || tie
  end

  def started?
    Time.current > start_time
  end

  def fetch_winner
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
        update_picks
      end
    end
    true
  end

  private

  def generate_picks
    week.membership_weeks.each do |membership_week|
      picks.create membership_week: membership_week
    end
  end
end
