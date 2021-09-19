class AddSendMailToLatePicks < ActiveRecord::Migration[6.1]
  def change
    add_column :group_weeks, :forgotten_picks_email, :datetime
  end
end
