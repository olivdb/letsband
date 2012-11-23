class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :update_last_seen

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end


  private
    def update_last_seen
	    return if !current_user
	    if current_user.last_seen_at.nil? || (current_user.last_seen_at < 1.day.ago)
	      current_user.last_seen_at = DateTime.now
	      current_user.save
	      sign_in current_user
	    end
  	end

end
