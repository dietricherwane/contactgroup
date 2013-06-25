class GroupMessageJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :groups_messages, :id => false do |t|
      t.integer :group_id
      t.integer :message_id
    end
    add_index :groups_messages, [:group_id, :message_id]
  end

  def self.down
  	drop_table :groups_messages
  end
end
