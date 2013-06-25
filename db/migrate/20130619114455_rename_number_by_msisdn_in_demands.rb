class RenameNumberByMsisdnInDemands < ActiveRecord::Migration
  def self.up
  	rename_column :demands, :number, :msisdn
  end

  def self.down
  	rename_column :demands, :msisdn, :number
  end
end
