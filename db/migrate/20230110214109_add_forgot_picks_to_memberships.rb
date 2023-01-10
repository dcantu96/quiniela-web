class AddForgotPicksToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :forgot_picks, :boolean, default: false
  end
end
