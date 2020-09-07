class CreateWeeks < ActiveRecord::Migration[6.0]
  def change
    create_table :weeks do |t|
      t.integer :number, null: false
      t.boolean :finished, null: false, default: false
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end

    add_index :weeks, [:number, :tournament_id], unique: true
  end
end
