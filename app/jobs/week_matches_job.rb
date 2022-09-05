class WeekMatchesJob < ApplicationJob 
  queue_as :default

  def perform(week_id)
    week = Week.find_by id: week_id
    if week.present?
      week.tournament.generate_week_matches(week.number)
    end
  end
end
