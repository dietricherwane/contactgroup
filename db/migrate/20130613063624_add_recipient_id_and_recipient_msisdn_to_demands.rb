class AddRecipientIdAndRecipientMsisdnToDemands < ActiveRecord::Migration
  def self.up
    add_column :demands, :recipient_id, :integer
    add_column :demands, :recipient_msisdn, :string
  end

  def self.down
    remove_column :demands, :recipient_msisdn
    remove_column :demands, :recipient_id
  end
end
