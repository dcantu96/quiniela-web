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
    matches.each { |m| m.fetch_result(espn_schedule_table) }
  end

  def reset_points(group)
    membership_weeks.where(group: group).each do |mw|
      mw.picks.each { |p| p.update correct: false }
      mw.update points: 0
    end
  end

  def espn_schedule_table
    # For this fetch to work team short names must be identical to ESPN's
    Nokogiri::HTML(URI.open("https://www.espn.com/nfl/schedule/_/week/#{number}/year/#{tournament.year}/seasontype/2"))
  end

  def generate_matches
    doc = espn_schedule_table
    espn_matches = doc.css('.responsive-table-wrap tr.even') + doc.css('.responsive-table-wrap tr.odd')
    espn_matches.each do |espn_match|
      return if espn_match.classes.include?('byeweek')

      espn_visit = espn_match.css('td')[0].text.split.last
      espn_home = espn_match.css('td')[1].text.split.last
      espn_match_date = espn_match.css('td')[2].values.second
      visit_team = Team.find_by(short_name: espn_visit)
      home_team = Team.find_by(short_name: espn_home)
      if matches.find_by(visit_team: visit_team).present?
        match = matches.find_by(visit_team: visit_team)
        unless match.home_team == home_team
          match.update home_team: home_team
        end
      elsif matches.find_by(home_team: home_team).present?
        match = matches.find_by(home_team: home_team)
        unless match.visit_team == visit_team
          match.update visit_team: visit_team
        end
      else
        matches.create home_team: home_team, visit_team: visit_team, start_time: espn_match_date
      end
    end
  end

  private

  def generate_group_weeks
    tournament.groups.each do |group|
      group_weeks.create group: group
    end
  end
end
