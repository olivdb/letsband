class ContactRecordsController < ApplicationController
  before_filter :signed_in_user

  def create
    current_user.contact_records.create!(contact_id: params[:contact_record][:contact_id])
    @user = User.find(params[:contact_record][:contact_id])
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
  	relationship = ContactRecord.find(params[:id])
    @user = relationship.contact
    relationship.destroy
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end