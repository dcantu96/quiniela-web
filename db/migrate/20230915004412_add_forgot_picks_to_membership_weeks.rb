class AddForgotPicksToMembershipWeeks < ActiveRecord::Migration[7.0]
  def change
    add_column :membership_weeks, :forgot_picks, :boolean, default: false
  end
end
