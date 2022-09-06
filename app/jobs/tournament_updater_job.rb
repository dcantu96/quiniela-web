class TournamentUpdaterJob < ApplicationJob 
  queue_as :default

  def perform(tournament_id)
    tournament = Tournament.find_by id: tournament_id
    if tournament.present?
      tournament.find_or_create_matches
      tournament.weeks.each do |week|
        week.update_match_picks
      end
      tournament.groups.each do |group|
        group.update_member_positions
      end
      AdminMailer.update_tournament_success(tournament).deliver_later
    end
  end
end
