class CreateLinklogs < ActiveRecord::Migration
  def self.up
    create_table :linklogs do |t|
      t.boolean :receive_message

      t.timestamps
    end
  end

  def self.down
    drop_table :linklogs
  end
end
