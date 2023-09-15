class TournamentWeekUpdaterJob < ApplicationJob 
  queue_as :default

  def perform(week_id)
    week = Week.find_by id: week_id
    if week.present?
      # fetch match results
      week.tournament.find_or_create_matches(week.number)
      
      # reset picks and week points
      week.picks.update_all correct: false
      week.membership_weeks.update_all points: 0, forgot_picks: false

      # update picks and week points
      week.update_match_picks # this will update picks and week points
      week.tournament.groups.each do |group|
        group.flag_invalid_membership_weeks_and_assign_lowest_valid_week_points(week.id) if week.finished
        group.update_member_positions
      end
      AdminMailer.update_week_success(week).deliver_later
    end
  end
end
