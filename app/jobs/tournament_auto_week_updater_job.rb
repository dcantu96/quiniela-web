class TournamentAutoWeekUpdaterJob < ApplicationJob 
  queue_as :default

  def perform(week_id)
    week = Week.find_by id: week_id
    if week.present?
      # fetch match results
      week.tournament.find_or_create_matches(week.number)
      
      # reset picks and week points
      week.picks.update_all correct: false
      week.membership_weeks.update_all points: 0

      # update picks and week points
      week.update_match_picks
      week.tournament.groups.each do |group|
        group.update_member_positions
      end
      AdminMailer.update_auto_week_success(week).deliver_later
    end
  end
end
