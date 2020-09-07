class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
