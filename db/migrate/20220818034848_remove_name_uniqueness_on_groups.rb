class RemoveNameUniquenessOnGroups < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|   
      dir.up do     
        remove_index :groups, :name  
        add_index :groups, :name
      end    
      dir.down do     
        remove_index :groups, :name
        add_index :groups, :name, unique: true
      end 
    end 
  end
end
