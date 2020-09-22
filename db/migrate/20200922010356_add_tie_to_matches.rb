class AddTieToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :tie, :boolean, default: false
  end
end
