task :update_current_week => :environment do
  year = '2024'
  tournament = Tournament.find_by(year: year)
  return if tournament.nil? || tournament.current_week.nil? || tournament.current_week.finished

  TournamentAutoWeekUpdaterJob.perform_later(tournament.current_week.id)
end