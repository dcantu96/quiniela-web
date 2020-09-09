class AddColumnToMembershipWeeks < ActiveRecord::Migration[6.0]
  def change
    add_reference :membership_weeks, :group, foreign_key: true

    MembershipWeek.all.each do |membership_week|
      membership_week.update group: membership_week.membership.group
    end
  end
end
