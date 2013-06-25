class AddDelayBeforeResendingDresendingDemandToParameters < ActiveRecord::Migration
  def self.up
    add_column :parameters, :delay_before_resending_demand, :integer
  end

  def self.down
    remove_column :parameters, :delay_before_resending_demand
  end
end
