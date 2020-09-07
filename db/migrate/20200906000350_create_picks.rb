class CreatePicks < ActiveRecord::Migration[6.0]
  def change
    create_table :picks do |t|
      t.references :membership, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.references :group_week, null: false, foreign_key: true
      t.references :picked_team, foreign_key: { to_table: :teams }
      t.boolean :correct, null: false, default: false
      t.integer :points, null: false, default: 0

      t.timestamps
    end
  end
end
