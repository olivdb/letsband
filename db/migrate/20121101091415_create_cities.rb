class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :country_id
      t.integer :region_id
      t.string :name
      t.float :longitude
      t.float :latitude

      t.timestamps
    end

    add_index :cities, [:name, :region_id, :country_id], unique: true, name: 'by_name_and_region_id_and_country_id'
    add_index :cities, :name
  end
end
