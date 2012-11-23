class Message < ActiveRecord::Base

  is_private_message
  validates :recipient_id, presence: true

  after_save :send_email_notification

  def send_email_notification
  	if self.inviting_band_id
  		MessageMailer.invitation_email(self).deliver
  	else
  		MessageMailer.message_email(self).deliver
  	end
  end
  
  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  #attr_accessor :to
  
end