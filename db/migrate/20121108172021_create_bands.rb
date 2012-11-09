class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.integer :city_id
      t.integer :genre_id
      t.text :description

      t.timestamps
    end
  end
end
