class UpdateMatchesJob
  include Sidekiq::Job
  sidekiq_options queue: 'default'

  def perform(tournament_id)
    tournament = Tournament.find_by id: tournament_id
    if tournament.present?
      tournament.generate_week_matches
    end
  end
end
