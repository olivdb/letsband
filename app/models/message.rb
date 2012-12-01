class Message < ActiveRecord::Base

  is_private_message
  validates :recipient_id, presence: true

  before_save :check_if_new
  after_save :send_email_notification

  def check_if_new
    @was_a_new_record = new_record?
    return true
  end
  def send_email_notification
    if @was_a_new_record
    	if self.inviting_band_id
    		MessageMailer.invitation_email(self).deliver
    	else
    		MessageMailer.message_email(self).deliver
    	end
    end
    return true
  end
  
  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  #attr_accessor :to
  
end