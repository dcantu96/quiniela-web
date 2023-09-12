class Week < ApplicationRecord
  belongs_to :tournament
  has_many :group_weeks, dependent: :destroy
  has_many :membership_weeks, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :picks, through: :matches
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
    matches.where.not(winning_team: nil).each do |match|
      match.update_picks
    end
  end

  def reset_points(group)
    membership_weeks.where(group: group).each do |mw|
      mw.picks.each { |p| p.update correct: false }
      mw.update points: 0
    end
  end

  def generate_matches(matches_json)
    match_order = 0
    matches_json.each do |match_json|
      match_time = Time.parse(match_json[:date])
      home_team = nil
      home_team_score = nil
      visit_team = nil
      visit_team_score = nil
      winning_team = nil

      competition = match_json[:competitions][0]
      next if competition.nil?
      competitors = competition[:competitors]
      next if competitors.nil? || competitors.count != 2

      competitors.each do |competitor|
        abbrev = competitor[:team][:abbreviation]
        is_home_team = competitor[:homeAway] == 'home'
        is_winner = competitor[:winner]
        score = competitor[:score] # is string

        team = Team.find_by(short_name: abbrev)
        if team.present?
          winning_team = team if is_winner
          if is_home_team
            home_team = team
            home_team_score = score
          else
            visit_team = team
            visit_team_score = score
          end
        end
      end

      # Match is all set by now. Now we need to update depending on if its a new match or not

      # 6. Try to find a valid matchup
      valid_match = matches.find_by(visit_team: visit_team, home_team: home_team)

      if valid_match.present?
        valid_match.update order: match_order, start_time: match_time, home_team_score: home_team_score, 
          visit_team_score: visit_team_score, winning_team: winning_team
        valid_match.generate_picks
      else
        new_match = matches.build order: match_order, start_time: match_time, home_team_score: home_team_score, 
          visit_team_score: visit_team_score, winning_team: winning_team, home_team: home_team, visit_team: visit_team
        if new_match.valid?
          # 9.1. This will also generate picks
          new_match.save
          puts 'new match saved!'
        else
          puts new_match.errors.full_messages
        end
      end
      
      match_order = match_order + 1
    end
  end

  # recieves: result_text = "PHI 32, ATL 6" | "" | nil
  # returns nil or the hash object
  def team_result(result_text)
    return nil if result_text.nil?
    return nil if result_text == ""

    result_arr = result_text.split(',')
    return nil if result_arr.length == 0
    first_team_raw = result_arr[0].split(' ') # ['BUF', '17']
    first_team_abbr = first_team_raw[0]
    first_team_score = first_team_raw[1].to_i

    second_team_raw = result_arr[1].split(' ') # ['CAR', '10']
    second_team_abbr = second_team_raw[0]
    second_team_score = second_team_raw[1].to_i

    return {
      first_team: {
        abbr: first_team_abbr,
        score: first_team_score
      },
      second_team: {
        abbr: second_team_abbr,
        score: second_team_score
      }
    }
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "finished", "id", "number", "tournament_id", "updated_at"]
  end

  private

  def generate_group_weeks
    tournament.groups.each do |group|
      group_weeks.create group: group
    end
  end
end
