class AddIndexes < ActiveRecord::Migration
  def self.up
  	add_index :users, :msisdn
  	
    add_index :groups, :user_id
    
    add_index :demands, :user_id
    add_index :demands, :group_id
    
    add_index :messages, :user_id
    
    add_index :links, :user_id
    add_index :links, :group_id
  end

  def self.down
  end
end
