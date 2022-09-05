class RemoveReferenceToGroupInMembershipWeeks < ActiveRecord::Migration[7.0]
  def change
    remove_reference :membership_weeks, :group, index: true
  end
end
