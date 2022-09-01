class UpdateMatchesJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(tournament_id)
    tournament = Tournament.find_by id: tournament_id
    if tournament.present?
      tournament.generate_week_matches
    end
  end
end
