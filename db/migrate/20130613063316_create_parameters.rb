class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.integer :demand_expiration_delay

      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end
