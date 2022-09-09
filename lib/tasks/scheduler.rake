task :update_current_week => :environment do
  year = '2022'
  tournament = Tournament.find_by(year: year)
  week = tournament.current_week
  if week.present?
    TournamentWeekUpdaterJob.perform_later(tournament.current_week.id)
  end
end