class CreateFavoriteGenres < ActiveRecord::Migration
  def change
    create_table :favorite_genres do |t|
      t.integer :user_id
      t.integer :genre_id
      t.boolean :looking_for_band

      t.timestamps
    end

    add_index :favorite_genres, :user_id
    add_index :favorite_genres, :genre_id
    add_index :favorite_genres, [:user_id, :genre_id], unique: true
  end
end
