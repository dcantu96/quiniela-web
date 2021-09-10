class AddModifiedByAdminToPicks < ActiveRecord::Migration[6.1]
  def change
    add_column :picks, :modified_by_admin, :boolean, default: false
  end
end
