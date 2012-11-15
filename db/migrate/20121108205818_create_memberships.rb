class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :band_id
      t.integer :instrument_id

      t.timestamps
    end
    add_index :memberships, [:user_id, :band_id], unique: true
  end
end
