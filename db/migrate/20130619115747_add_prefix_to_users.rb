class AddPrefixToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :prefix, :string
  end

  def self.down
    remove_column :users, :prefix
  end
end
