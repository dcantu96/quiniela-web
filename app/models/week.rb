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
    base_url = 'https://www.espn.com'
    tables = doc.css('div.ResponsiveTable')
    match_order = 0
    tables.each do |table|
      # 1. If the row is showing bye week matches continue to next row
      bye_text = table.css('.Table__THEAD .Table__TH').text
      return if bye_text.downcase === 'bye'

      table_rows =  table.css('tbody.Table__TBODY tr')
      table_rows.each do |row|
        # 2. Get and parse match teams text

        # 3. Fetch and parse match teams text
        match_url = row.css('.date__col').first.children.first.attributes['href'].value
        match_doc = Nokogiri::HTML(URI.open(base_url + match_url))
        away_team_abbrev = match_doc.css('.team.away span.abbrev')[0].text
        home_team_abbrev = match_doc.css('.team.home span.abbrev')[0].text

        # 4. Find teams
        visit_team = Team.find_by short_name: away_team_abbrev
        home_team = Team.find_by short_name: home_team_abbrev

        # 5. Guard clause if teams not found
        return if visit_team.nil? || home_team.nil?

        # 6. Find any invalid matches
        invalid_visit_team_matches = matches.where(visit_team: visit_team).where.not(home_team: home_team)
        invalid_home_team_matches = matches.where(home_team: home_team).where.not(visit_team: visit_team)
        if invalid_visit_team_matches.present?
          invalid_visit_team_matches.destroy_all
        end
        if invalid_home_team_matches.present?
          invalid_home_team_matches.destroy_all
        end

        # 7. Try to find a valid matchup
        valid_match = matches.find_by(visit_team: visit_team, home_team: home_team)


        game_time_container = match_doc.css('.game-status span')[1]
        maybe_time = game_time_container.present? ? game_time_container.attr('data-date') : nil
        match_time = maybe_time.present? ? Time.parse(maybe_time) : nil

        # 8. If there is one, update the time if it is different
        if valid_match.present?
          if match_time.nil?
            valid_match.update start_time: nil
          else
            if valid_match.start_time != match_time
              valid_match.update start_time: match_time
            end
          end
          if valid_match.order != match_order
            valid_match.update order: match_order
          end
        else
          # 9. lastly, we create the valid matchup
          new_match = matches.build home_team: home_team, visit_team: visit_team, start_time: match_time, order: match_order
          if new_match.valid?
            new_match.save
            puts 'save match'
          else
            puts new_match.errors.full_messages
          end
        end
        match_order = match_order + 1
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
