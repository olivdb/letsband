class AddImageWidthAndImageHeightToBands < ActiveRecord::Migration
  def change
    add_column :bands, :image_width, :integer
    add_column :bands, :image_height, :integer
  end
end
