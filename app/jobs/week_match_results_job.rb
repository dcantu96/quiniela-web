class WeekMatchResultsJob < ApplicationJob 
  queue_as :default

  def perform(week_id)
    week = Week.find_by id: week_id
    if week.present?
      week.tournament.update_week_matches(week.number)
      week.update_match_picks
      week.tournament.groups.each do |group|
        group.update_member_positions
      end
      AdminMailer.update_success(week, group).deliver_now
    end
  end
end
