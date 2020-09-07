class CreateTournaments < ActiveRecord::Migration[6.0]
  def change
    create_table :tournaments do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
