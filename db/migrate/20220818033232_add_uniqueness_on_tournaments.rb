class AddUniquenessOnTournaments < ActiveRecord::Migration[7.0]
  def change
    add_index :tournaments, [:name, :year], unique: true
  end
end
