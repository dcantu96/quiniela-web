class ChangeDefaultValueForTimeZoneForUser < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :time_zone, 'America/Monterrey' 
  end
end
