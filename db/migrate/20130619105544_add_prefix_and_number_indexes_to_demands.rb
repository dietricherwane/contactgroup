class AddPrefixAndNumberIndexesToDemands < ActiveRecord::Migration
  def self.up
  	add_index :demands, :prefix
    add_index :demands, :number
  end

  def self.down
  end
end
