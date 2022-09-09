task :update_current_week => :environment do
  year = '2022'
  tournament = Tournament.find_by(year: year)
  return if tournament.nil?

  week = tournament.current_week
  return if week.nil?
  
  TournamentWeekUpdaterJob.perform_later(tournament.current_week.id)
end