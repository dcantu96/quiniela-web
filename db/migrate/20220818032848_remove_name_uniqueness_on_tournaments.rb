class RemoveNameUniquenessOnTournaments < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|   
      dir.up do     
        remove_index :tournaments, :name  
        add_index :tournaments, :name
      end    
      dir.down do     
        remove_index :tournaments, :name
        add_index :tournaments, :name, unique: true
      end 
    end 
  end
end
