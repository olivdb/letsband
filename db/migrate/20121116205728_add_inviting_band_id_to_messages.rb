class AddInvitingBandIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :inviting_band_id, :integer
  end
end
