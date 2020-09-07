class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.datetime :start_time, null: false
      t.references :week, null: false, foreign_key: true
      t.references :visit_team, null: false, foreign_key: { to_table: :teams }
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :winning_team, foreign_key: { to_table: :teams }
      t.boolean :untie, default: false
      t.boolean :premium, default: false
      t.integer :visit_team_score
      t.integer :home_team_score

      t.timestamps
    end
  end
end
