class AddPublishedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :published, :boolean
  end

  def self.down
    remove_column :users, :published
  end
end
