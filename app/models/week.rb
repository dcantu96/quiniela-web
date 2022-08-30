class Week < ApplicationRecord
  belongs_to :tournament
  has_many :group_weeks, dependent: :destroy
  has_many :membership_weeks, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :groups, through: :group_weeks
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
    # Fetch once
    schedule = espn_schedule_table
    matches.each { |m| m.fetch_result(schedule) }
  end

  def reset_points(group)
    membership_weeks.where(group: group).each do |mw|
      mw.picks.each { |p| p.update correct: false }
      mw.update points: 0
    end
  end

  def espn_schedule_table
    # For this fetch to work team short names must be identical to ESPN's
    @espn_schedule_table ||= Nokogiri::HTML(URI.open("https://www.espn.com/nfl/schedule/_/week/#{number}/year/#{tournament.year}/seasontype/2"))
  end

  def generate_matches(doc=espn_schedule_table)
    tables = doc.css('div.ResponsiveTable')
    tables.each do |table|
      # 1. If the row is showing bye week matches continue to next row
      bye_text = table.css('div.ResponsiveTable Table__THEAD Table__TH').text
      return if bye_text.downcase === 'bye'

      # 2. Set match values
      day = table.css('div.Table__Title').first.children.text
      away_team_text = table.css('tbody.Table__TBODY tr td')[0].text
      home_team_text = table.css('tbody.Table__TBODY tr td')[1].text
      espn_time_text = table.css('tbody.Table__TBODY tr td')[2].text
      match_time = Time.zone.parse(day + espn_time_text)

      home_team_text.delete! '@'
      home_team_text.squish!

      puts 'away_team_text'
      puts away_team_text

      puts 'home_team_text'
      puts home_team_text

      puts 'espn_time_text'
      puts espn_time_text

      puts 'match_time'
      puts match_time

      # 3. Find teams
      visit_team = Team.where("name like ?", "%#{away_team_text}%").first
      home_team = Team.where("name like ?", "%#{home_team_text}%").first

      # 4. Guard clause if teams not found
      return if visit_team.nil? || home_team.nil?

      # 5. Find any invalid matches
      invalid_visit_team_matches = matches.where(visit_team: visit_team).where.not(home_team: home_team)
      invalid_home_team_matches = matches.where(home_team: home_team).where.not(visit_team: visit_team)
      if invalid_visit_team_matches.present?
        invalid_visit_team_matches.destroy
      end
      if invalid_home_team_matches.present?
        invalid_home_team_matches.destroy
      end
      
      puts 'invalid_visit_team_matches'
      puts invalid_visit_team_matches.length

      puts 'invalid_home_team_matches'
      puts invalid_home_team_matches.length

      puts 'match_time'
      puts match_time

      # 6. Try to find a valid matchup
      valid_match = matches.find_by(visit_team: visit_team, home_team: home_team)

      # 7. If there is one, update the time if it is different
      if valid_match.present?
        puts 'valid match present'
        puts valid_match.start_time != match_time
        puts valid_match.home_team.name
        puts valid_match.visit_team.name
        puts valid_match.week.number
        puts valid_match.start_time
        # if valid_match.start_time != match_time
        #   puts 'update time to: '
        #   puts match_time
        #   valid_match.update start_time: match_time
        # end
      else
        # 8. lastly, we create the valid matchup
        puts 'create_match'
        puts home_team.name
        puts visit_team.name
        puts match_time
        new_match = matches.build home_team: home_team, visit_team: visit_team, start_time: match_time
        if new_match.save?
          puts 'save match'
        else
          puts new_match.errors.full_messages
        end
      end
    end
  end

  def update_matches
    doc = espn_schedule_table
    matches.each do |match|
      match.fetch_result(doc)
    end
  end

  private

  def generate_group_weeks
    tournament.groups.each do |group|
      group_weeks.create group: group
    end
  end
end
