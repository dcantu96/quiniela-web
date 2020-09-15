class CreateWinners < ActiveRecord::Migration[6.0]
  def change
    create_table :winners do |t|
      t.references :membership_week, null: false, foreign_key: true

      t.timestamps
    end
  end
end
