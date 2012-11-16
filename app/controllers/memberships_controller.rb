class MembershipsController < ApplicationController
  load_and_authorize_resource

  def destroy
    @band = @membership.band
    @user = @membership.user
    @membership.destroy
    respond_to do |format|
      format.html { render edit_user_path(@user, :section => 'bands') }
      format.js
    end
  end

  def convert_to_member
    @membership.role = "member"
    band = Band.find(@membership.band_id)
    if @membership.save
      if @membership.user_id == current_user.id
        flash[:success] = "You have joined " + band.name + " !"
        redirect_to band_path(@membership.band)
      else
        flash[:success] = User.find(@membership.user_id).fullname + " has been given the status of Member for " + band.name
        redirect_to :back
      end
    end
  end

  def convert_to_manager
    @membership.role = "manager"
    if @membership.save
      if @membership.user_id == current_user.id
        message = "You have "
      else
        message = User.find(@membership.user_id).fullname + " has " 
      end
      flash[:success] = message + "been given the status of Manager for " + Band.find(@membership.band_id).name
    end
    redirect_to :back
  end

  def convert_to_owner
    @membership.role = "owner"
    if @membership.save
      if @membership.user_id == current_user.id
        message = "You have "
      else
        message = User.find(@membership.user_id).fullname + " has " 
      end
      flash[:success] = message + "been given the status of Manager for " + Band.find(@membership.band_id).name
    end
    redirect_to :back
  end

  def change_instrument
    @membership.instrument_id = params[:instrument_id]
    if @membership.save
      if @membership.user_id == current_user.id
        message = "You are "
      else
        message = User.find(@membership.user_id).fullname + " is " 
      end
      flash[:success] = message + "now playing " + Instrument.find(@membership.instrument_id).name + " in " + Band.find(@membership.band_id).name
    end
    redirect_to :back
  end


end