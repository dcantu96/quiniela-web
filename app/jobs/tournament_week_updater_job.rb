class TournamentWeekUpdaterJob < ApplicationJob 
  queue_as :default

  def perform(week_id)
    week = Week.find_by id: week_id
    if week.present?
      week.tournament.find_or_create_matches(week.number)
      week.update_match_picks
      week.tournament.groups.each do |group|
        group.update_member_positions
      end
      AdminMailer.update_week_success(week).deliver_later
    end
  end
end
