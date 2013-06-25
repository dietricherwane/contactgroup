class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :receive_messages
      t.boolean :deleted
      t.datetime :cancellation_date

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
