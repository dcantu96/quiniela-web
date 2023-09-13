class AddJoinableToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :joinable, :boolean, default: false
  end
end
