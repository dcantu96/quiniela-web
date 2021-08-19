User.create email: 'example@admin.com',
            password: 123456,
            phone: 8110228910,
            full_name: 'David Cantu'

User.last.add_role :admin

Sport.create name: 'American Football'
Tournament.create name: 'National Football League', sport: Sport.first
Group.create name: 'QNFL MTY 2021', tournament: Tournament.first

TEAMS = [
  ['ARI', 'Arizona Cardinals'],
  ['ATL', 'Atlanta Falcons'],
  ['BAL', 'Baltimore Ravens'],
  ['BUF', 'Buffalo Bills'],
  ['CAR', 'Carolina Panthers'],
  ['CHI', 'Chicago Bears'],
  ['CIN', 'Cincinnati Bengals'],
  ['CLE', 'Cleveland Browns'],
  ['DAL', 'Dallas Cowboys'],
  ['DEN', 'Denver Broncos'],
  ['DET', 'Detroit Lions'],
  ['GB', 'Green Bay Packers'],
  ['HOU', 'Houston Texans'],
  ['IND', 'Indianapolis Colts'],
  ['JAX', 'Jacksonville Jaguars'],
  ['KC', 'Kansas City Chiefs'],
  ['MIA', 'Miami Dolphins'],
  ['MIN', 'Minnesota Vikings'],
  ['NE', 'New England Patriots'],
  ['NO', 'New Orleans Saints'],
  ['NYG', 'New York Giants'],
  ['NYJ', 'New York Jets'],
  ['OAK', 'Oakland Raiders'],
  ['PHI', 'Philadelphia Eagles'],
  ['PIT', 'Pittsburgh Steelers'],
  ['LAC', 'Los Angeles Chargers'],
  ['SEA', 'Seattle Seahawks'],
  ['SF', 'San Francisco 49ers'],
  ['LAR', 'Los Angeles Rams'],
  ['LV', 'Las Vegas Raiders'],
  ['TB', 'Tampa Bay Buccaneers'],
  ['TEN', 'Tennessee Titans'],
  ['WSH', 'Washington']
]

TEAMS.each do |team|
  Team.create short_name: team.first, name: team.second, sport: Sport.first
end

# Week.create tournament: Tournament.first, number: 1
# Week.create tournament: Tournament.first, number: 2
# Week.create tournament: Tournament.first, number: 3
# Week.create tournament: Tournament.first, number: 4
# Week.create tournament: Tournament.first, number: 5
# Week.create tournament: Tournament.first, number: 6
# Week.create tournament: Tournament.first, number: 7
# Week.create tournament: Tournament.first, number: 8
# Week.create tournament: Tournament.first, number: 9
# Week.create tournament: Tournament.first, number: 10
# Week.create tournament: Tournament.first, number: 11
# Week.create tournament: Tournament.first, number: 12
# Week.create tournament: Tournament.first, number: 13
# Week.create tournament: Tournament.first, number: 14
# Week.create tournament: Tournament.first, number: 15
# Week.create tournament: Tournament.first, number: 16
# Week.create tournament: Tournament.first, number: 17

# Create all week matches
# Tournament.first.weeks.each do |week|
#   doc = Nokogiri::HTML(open("https://www.espn.com/nfl/schedule/_/week/#{week.number}/seasontype/2"))
#   dates = doc.xpath('//td/@data-date').map { |d| d.text }
#   co = 0
#   doc.css('div .responsive-table-wrap').each do |table|
#     table.css('tbody').each do |body|
#       body.css('tr').each do |match|
#         Match.create visit_team: Team.find_by(short_name: match.css('td .team-name abbr').first.text),
#                      home_team: Team.find_by(short_name: match.css('td .team-name abbr').last.text),
#                      start_time: dates[co],
#                      week: week
#         co = co + 1
#       end
#     end
#   end
# end