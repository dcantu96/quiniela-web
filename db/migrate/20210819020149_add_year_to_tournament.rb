class AddYearToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :year, :string
  end
end
