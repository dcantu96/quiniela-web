class ReplaceYearFromTournamentsToGroupBack < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :year, :string
    add_column :tournaments, :year, :string
  end
end
