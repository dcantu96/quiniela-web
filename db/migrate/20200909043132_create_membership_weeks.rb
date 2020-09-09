class CreateMembershipWeeks < ActiveRecord::Migration[6.0]
  def change
    create_table :membership_weeks do |t|
      t.references :membership, null: false, foreign_key: true
      t.references :week, null: false, foreign_key: true
      t.integer :points, null: false, default: 0

      t.timestamps
    end
    Week.all.each do |week|
      Membership.all.each do |membership|
        MembershipWeek.create week: week, membership: membership
      end
    end

    add_reference :picks, :membership_week, foreign_key: true

    MembershipWeek.all.each do |membership_week|
      membership_week.membership.picks.where(group_week: GroupWeek.find_by(group: membership_week.membership.group, week: membership_week.week)).each do |pick|
        pick.update membership_week: membership_week
      end
    end

    remove_reference :picks, :membership, foreign_key: true
    remove_reference :picks, :group_week, foreign_key: true

  end
end
