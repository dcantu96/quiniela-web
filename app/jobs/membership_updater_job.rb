class MembershipUpdaterJob < ApplicationJob 
  queue_as :default

  def perform(group_id)
    group = Group.find_by id: group_id
    if group.present?
      group.memberships.update_all forgot_picks: false
      group.membership_weeks.includes(:membership, :picks, :week).each do |membership_week|
        forgotten_picks = membership_week.week.finished? ? membership_week.picks.where(picked_team_id: nil).count : 0
        membership_week.membership.update forgot_picks: true if forgotten_picks >= 6
      end
      AdminMailer.update_memberships_success(group).deliver_later
    end
  end
end
