class CreateSports < ActiveRecord::Migration[6.0]
  def change
    create_table :sports do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
