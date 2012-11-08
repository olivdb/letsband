class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :user_id
      t.integer :instrument_id
      t.integer :priority
      t.integer :expertise
      t.integer :experience
      t.integer :education


      t.timestamps
    end

    add_index :skills, :user_id
    add_index :skills, :instrument_id
    add_index :skills, [:user_id, :instrument_id], unique: true
  end
end
