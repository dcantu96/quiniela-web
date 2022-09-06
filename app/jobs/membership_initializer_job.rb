class MembershipInitializerJob < ApplicationJob 
  queue_as :default

  def perform(membership_id)
    membership = Membership.includes(group: [tournament: [weeks: [:matches]]], membership_weeks: [:picks]).find_by(id: membership_id)
    if membership.present?
      membership.membership_weeks.destroy_all
      membership.group.tournament.weeks.each do |week|
        membership_week = membership.membership_weeks.find_or_create_by week: week
        week.matches.each do |match|
          membership_week.picks.find_or_create_by! match: match
        end
      end
    end
  end
end
