class CreateContactRecords < ActiveRecord::Migration
  def change
    create_table :contact_records do |t|
      t.integer :owner_id
      t.integer :contact_id

      t.timestamps
    end

    add_index :contact_records, :owner_id
    add_index :contact_records, [:owner_id, :contact_id], unique: true
  end
end
