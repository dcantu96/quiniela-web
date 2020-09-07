# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create email: 'example@admin.com',
            password: 123456,
            phone: 8181818181,
            full_name: 'David Cantu'

User.last.confirm
User.last.add_role :admin

Sport.create name: 'American Football'
Tournament.create name: 'National Football League', sport: Sport.first
Group.create name: 'QNFL MTY 2020', tournament: Tournament.first

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
  ['SD', 'San Diego Chargers'],
  ['SEA', 'Seattle Seahawks'],
  ['SF', 'San Francisco 49ers'],
  ['STL', 'Saint Louis Rams'],
  ['TB', 'Tampa Bay Buccaneers'],
  ['TEN', 'Tennessee Titans'],
  ['WSH', 'Washington Warriors']
]

TEAMS.each do |team|
  Team.create short_name: team.first, name: team.second, sport: Sport.first
end

Week.create tournament: Tournament.first, number: 1
Week.create tournament: Tournament.first, number: 2
Week.create tournament: Tournament.first, number: 3
Week.create tournament: Tournament.first, number: 4
Week.create tournament: Tournament.first, number: 5
Week.create tournament: Tournament.first, number: 6
Week.create tournament: Tournament.first, number: 7
Week.create tournament: Tournament.first, number: 8
Week.create tournament: Tournament.first, number: 9
Week.create tournament: Tournament.first, number: 10
Week.create tournament: Tournament.first, number: 11
Week.create tournament: Tournament.first, number: 12
Week.create tournament: Tournament.first, number: 13
Week.create tournament: Tournament.first, number: 14
Week.create tournament: Tournament.first, number: 15
Week.create tournament: Tournament.first, number: 16
Week.create tournament: Tournament.first, number: 17