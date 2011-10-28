class RemoveUser < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def down
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.timestamps
      t.boolean :admin # Not sure if this is correct
    end

    add_index :users, :email, :unique => true
  end
end
