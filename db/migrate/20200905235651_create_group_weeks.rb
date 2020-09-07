class CreateGroupWeeks < ActiveRecord::Migration[6.0]
  def change
    create_table :group_weeks do |t|
      t.references :group, null: false, foreign_key: true
      t.references :week, null: false, foreign_key: true
      t.references :winner, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
