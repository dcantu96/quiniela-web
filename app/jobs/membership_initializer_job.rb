class MembershipInitializerJob < ApplicationJob 
  queue_as :default

  def perform(membership_id)
    membership = Membership.includes(group: [tournament: [weeks: [:matches]]], membership_weeks: [:picks]).find_by(id: membership_id)
    if membership.present?
      membership.group.tournament.weeks.each do |week|
        membership_week = membership.membership_weeks.find_or_create_by week: week
        week.matches.each do |match|
          pick = membership_week.picks.find_or_create_by! match: match
        end
      end
      membership.picks.update_all picked_team_id: nil, modified_by_admin: false
    end
  end
end
