class AddOriginMessageIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :origin_message_id, :integer
  end
end
