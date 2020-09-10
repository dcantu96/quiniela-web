class AddColumnsToMembershipsOfPaid < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :paid, :boolean, default: false
    add_column :memberships, :suspended, :boolean, default: false
    add_column :memberships, :notes, :string
  end
end
