class AddPositionToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :position, :integer, default: 0
    add_column :memberships, :total, :integer, default: 0
  end
end
