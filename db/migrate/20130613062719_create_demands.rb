class CreateDemands < ActiveRecord::Migration
  def self.up
    create_table :demands do |t|
      t.integer :group_id
      t.integer :user_id
      t.boolean :accepted
      t.datetime :decision_date

      t.timestamps
    end
  end

  def self.down
    drop_table :demands
  end
end
