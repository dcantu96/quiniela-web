class Week < ApplicationRecord
  belongs_to :tournament
  has_many :group_weeks, dependent: :destroy
  has_many :membership_weeks, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :groups, through: :group_weeks
  after_create :generate_group_weeks
  validates :number, uniqueness: { scope: :tournament }

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

  def update_match_picks
    matches.each do |match|
      match.update_picks if match.winning_team.present?
    end
  end

  def reset_points(group)
    membership_weeks.where(group: group).each do |mw|
      mw.picks.each { |p| p.update correct: false }
      mw.update points: 0
    end
  end

  def generate_matches(doc)
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
        scheduled_match = row.css('.date__col a')
        settled_match = row.css('.teams__col a')
        away_team_abbrev = nil
        home_team_abbrev = nil
        match_url = nil
        match_doc = nil

        if settled_match.text.present?
          match_url = settled_match.first.attributes['href'].value
          match_doc = Nokogiri::HTML(URI.open(base_url + match_url))
        else
          match_url = scheduled_match.first.attributes['href'].value
          match_doc = Nokogiri::HTML(URI.open(base_url + match_url))
        end

        away_team_abbrev = match_doc.css('.team.away span.abbrev').text
        home_team_abbrev = match_doc.css('.team.home span.abbrev').text

        # 4. Find teams
        visit_team = Team.find_by short_name: away_team_abbrev
        home_team = Team.find_by short_name: home_team_abbrev

        # 5. Guard clause if teams not found
        next if visit_team.nil? || home_team.nil?

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

        # 8. If there is one, update the match
        if valid_match.present?
          if match_time.present?
            if valid_match.start_time != match_time
              valid_match.update start_time: match_time
            end
          end
          if valid_match.order != match_order
            valid_match.update order: match_order
          end
          # 8.1. Generate valid picks for all memberships
          valid_match.generate_picks
        else
          # 9. lastly, we create the valid matchup
          new_match = matches.build home_team: home_team, visit_team: visit_team, start_time: match_time, order: match_order
          if new_match.valid?
            # 9.1. This will also generate picks
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

  def update_match_results(doc)
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

        # 3. Fetch result text
        result_text_container = row.css('td.teams__col.Table__TD a')[0]
        next if result_text_container.nil?

        result_text = result_text_container.text
        next if result_text.nil?

        result_arr = result_text.split(',')
        next if result_arr.length == 0

        first_team_raw = result_arr[0].split(' ') # ['BUF', '17']
        first_team_abbr = first_team_raw[0]
        first_team_score = first_team_raw[1].to_i

        second_team_raw = result_arr[1].split(' ') # ['CAR', '10']
        second_team_abbr = second_team_raw[0]
        second_team_score = second_team_raw[1].to_i

        # 4. Find teams
        first_team = Team.find_by short_name: first_team_abbr
        second_team = Team.find_by short_name: second_team_abbr

        # 5. Guard clause if teams not found
        next if first_team.nil? || second_team.nil?

        # 7. Try to find a valid matchup
        valid_matches = matches.where(visit_team: [first_team, second_team])

        # 8. If there is one, update the match
        if valid_matches.present? && valid_matches.count == 1
          valid_match = valid_matches.first
          if first_team_score == second_team_score
            valid_match.update visit_team_score: second_team_score, home_team_score: second_team_score, tie: true
          else
            if valid_match.home_team.short_name == first_team_abbr
              # first team is home team
              home_team_score = first_team_score
              visit_team_score = second_team_score
              valid_match.update visit_team_score: visit_team_score,
                home_team_score: home_team_score, 
                winning_team: home_team_score > visit_team_score ? valid_match.home_team : valid_match.visit_team
            else
              # second team is home team
              home_team_score = second_team_score
              visit_team_score = first_team_score
              valid_match.update visit_team_score: visit_team_score,
                home_team_score: home_team_score, 
                winning_team: home_team_score > visit_team_score ? valid_match.home_team : valid_match.visit_team
            end
          end
        else
          # 9. lastly, we create the valid matchup
          puts 'no valid match found!'
          next
        end
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
