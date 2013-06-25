class RemoveRecipientIdAndRecipientMsisdnFromDemands < ActiveRecord::Migration
  def self.up
  	remove_column :demands, :recipient_id
  	remove_column :demands, :recipient_msisdn
  end

  def self.down
  end
end
