class AddLinkIdToLinklogs < ActiveRecord::Migration
  def self.up
    add_column :linklogs, :link_id, :integer
  end

  def self.down
    remove_column :linklogs, :link_id
  end
end
