class AddPrefixAndNumberToDemands < ActiveRecord::Migration
  def self.up
    add_column :demands, :prefix, :string
    add_column :demands, :number, :string
  end

  def self.down
    remove_column :demands, :number
    remove_column :demands, :prefix
  end
end
