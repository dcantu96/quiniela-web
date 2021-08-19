class RemoveConstraintForStartTime < ActiveRecord::Migration[6.1]
  def change
    change_column :matches, :start_time, :datetime, :null => true
  end
end
