class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.confirmed_at 
        sign_in user
        redirect_back_or user
      else
        notice = %Q[Your account has not yet been activated. 
          Please follow the instructions sent in the confirmation email that has been sent to you. 
          To re-send the confirmation email, click <a href="#{url_for :controller => 'confirmations', :action => 'new'}">here</a>.]
        flash.now[:notice] = notice
        render 'new'
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  	sign_out
    redirect_to root_url
  end
end