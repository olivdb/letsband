class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :user_id
      t.integer :instrument_id
      t.integer :expertise
      t.integer :interest

      t.timestamps
    end

    add_index :skills, :user_id
    add_index :skills, :instrument_id
    add_index :skills, [:user_id, :instrument_id], unique: true
  end
end
