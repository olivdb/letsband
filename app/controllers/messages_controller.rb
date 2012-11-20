class MessagesController < ApplicationController
before_filter :signed_in_user

  def show
  	@message = Message.read_message(params[:id], current_user)
  end

  def new
  	@message = Message.new
    params[:message] = {}
    params[:message][:subject] = params[:subject] if params[:subject].present?
    params[:message][:origin_message_id] = params[:origin_message_id] if params[:origin_message_id].present?
    puts ">>>>>>>>"+params.inspect
    render :action => 'new', :locals => {:recipient_id => params[:recipient_id]}
  end

  def create
    @message = Message.new
    @message.recipient_id = params[:message][:recipient_id]
    @message.sender_id = current_user.id
    @message.subject = params[:message][:subject]
    @message.body = params[:message][:body]
    @message.origin_message_id = params[:message][:origin_message_id]

    if @message.save
      flash[:success] = "Message sent."
      redirect_to received_messages_url
    else
      render :action => 'new', :locals => {:recipient_id => params[:message][:recipient_id]}
    end
  end

  def received
  	@messages = current_user.received_messages.paginate(page: params[:page], per_page: 20)
  end

  def sent
  	@messages = current_user.sent_messages.paginate(page: params[:page], per_page: 20)
  end

  def destroy
  	Message.find(params[:id]).mark_deleted(current_user)
    flash[:success] = "Message deleted."
    redirect_to received_messages_url
  end
end
