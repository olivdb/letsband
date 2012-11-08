class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :country_id
      t.string :name
      t.string :code

      t.timestamps
    end

    add_index :regions, [:code, :country_id], unique: true, name: 'by_code_and_country_id'
  end
end
