class AddImageNameToBands < ActiveRecord::Migration
  def change
    add_column :bands, :image_name, :string
  end
end
