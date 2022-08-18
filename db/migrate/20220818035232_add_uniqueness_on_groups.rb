class AddUniquenessOnGroups < ActiveRecord::Migration[7.0]
  def change
    add_index :groups, [:name, :tournament_id], unique: true
  end
end
