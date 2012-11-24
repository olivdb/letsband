class UsersController < ApplicationController
  require "will_paginate/array"
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user,   only: [:edit, :update, :contacts]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_confirmation_instructions
      #sign_in @user
      flash[:success] = ("Hi " + @user.firstname + "! Welcome to Let's Band! A confirmation email has been sent to you that will allow you to active your account.")
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
      if(params[:user_city_has_been_selected] == '0')
        if(!params[:user_city_name].blank?)
          city = City.find_by_fullname(params[:user_city_name]) || City.order(:name).where("LOWER(name) like ?", "#{params[:user_city_name].downcase}%").limit(1).first
          if city.present?
            params[:user_city_id] = city.id
            params[:user_city_name] = city.fullname
          else
            params[:user_city_id] = 0
            params[:user_city_name] = ''
          end
        else
          params[:user_city_id] = 0
        end
      end
      @users = User.get_filtered(params)
  end

  def edit
    @user = User.find(params[:id])
    if(params[:section].nil?)
      params[:section] = 'general'
    end
    if(params[:section] == 'general')
      @user.updating_password = true
    else
      @user.updating_password = false
    end
  end

  def update
    if(params[:section]=='location')
      if(params[:user_city_has_been_selected] == '0')
        if(!params[:user_city_name].blank?)
          city = City.find_by_fullname(params[:user_city_name]) || City.order(:name).where("LOWER(name) like ?", "#{params[:user_city_name].downcase}%").limit(1).first
          if city.present?
            params[:user][:city_id] = city.id
          else
            #no city update
          end
        else
          #no city update
        end
      end
    elsif(params[:section]=='skills')
      @user.skills.destroy_all
      params[:user][:skills_attributes].each do |skill|
        skill[1]=skill[1].delete_if {|key, value| key  == "id" }
        hash = { :skills_attributes => { '0' => skill[1] } }
        @user.update_attributes(hash)
      end
      sign_in @user
      if !@user.errors.any?
        flash.now[:success] = "Profile updated"
        render 'show'
      else
        render 'edit'
      end
      return
    end

    if @user.update_attributes(params[:user])
      extra = (params[:user][:email] != @user.email) ? "You will receive an email to confirm your new account email in a few minutes." : ""
      flash.now[:success] = "Profile updated. " + extra
      
      sign_in @user
      render 'show'
    else
      render 'edit'
    end
  end

  def contacts
    @user = User.find(params[:id])
    @users = @user.contacts.paginate(page: params[:page])
    render :action =>'contacts', :layout => 'messages'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
end
