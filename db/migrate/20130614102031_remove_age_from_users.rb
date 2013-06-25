class RemoveAgeFromUsers < ActiveRecord::Migration
  def self.up
  	remove_column :users, :age
  end

  def self.down
  end
end
