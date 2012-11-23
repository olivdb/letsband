class MessageMailer < ActionMailer::Base
  add_template_helper(UsersHelper)
  
  default from: "Let's Band! <noreply.letsband@gmail.com>"

  def message_email(message)
  	@message = message
  	email_with_name = "#{message.recipient.name} <#{message.recipient.email}>"
  	mail(to: email_with_name, subject: (message.sender.name + " has sent you a message on Let's Band!"))
  end

  def invitation_email(invitation)
  	@message = invitation
  	email_with_name = "#{invitation.recipient.name} <#{invitation.recipient.email}>"
  	mail(to: email_with_name, subject: (invitation.sender.name + " has invited you to join \"#{Band.find(invitation.inviting_band_id).name}\" on Let's Band!"))
  end
end
