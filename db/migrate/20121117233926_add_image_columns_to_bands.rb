class AddImageColumnsToBands < ActiveRecord::Migration
  def self.up
    add_attachment :bands, :image
  end

  def self.down
    remove_attachment :bands, :image
  end
end