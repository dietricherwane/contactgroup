class AddAdherentIdToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :adherent_id, :integer
  end

  def self.down
    remove_column :links, :adherent_id
  end
end
