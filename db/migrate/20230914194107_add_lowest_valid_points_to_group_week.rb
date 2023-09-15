class AddLowestValidPointsToGroupWeek < ActiveRecord::Migration[7.0]
  def change
    add_column :group_weeks, :lowest_valid_points, :integer
  end
end
