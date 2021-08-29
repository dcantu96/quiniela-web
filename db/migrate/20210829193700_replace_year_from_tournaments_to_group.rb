class ReplaceYearFromTournamentsToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :year, :string
    remove_column :tournaments, :year, :string
  end
end
