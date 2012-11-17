class BandsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  load_and_authorize_resource except: :index
  
  def new
  end

  def create
     if @band.save
      current_user.memberships.create!(band_id: @band.id, role: "owner", instrument_id: Instrument.find_by_name('Unknown').id)
      flash[:success] = (@band.name + " is born!")
      redirect_to @band
    else
      render 'new'
    end
  end

  def index
	  if(params[:band_city_has_been_selected] == '0')
	    if(!params[:band_city_name].blank?)
	      city = City.find_by_fullname(params[:band_city_name]) || City.order(:name).where("LOWER(name) like ?", "#{params[:band_city_name].downcase}%").limit(1).first
	      if city.present?
	        params[:band_city_id] = city.id
	        params[:band_city_name] = city.fullname
	      else
	        params[:band_city_id] = 0
	        params[:band_city_name] = ''
	      end
	    else
	      params[:band_city_id] = 0
	    end
	  end
	  @bands = Band.get_filtered(params)
    authorize! :read, @bands
  end

  def show
  end

  def destroy
    @band = Band.find(params[:id])
    @user = membership.user
    @band.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_path(@user, :section => 'bands') }
      format.js
    end
  end


  def edit
    if(params[:section].nil?)
      params[:section] = 'presentation'
    end
  end

  def update
    if(params[:section]=='location')
      if(params[:band_city_has_been_selected] == '0')
        if(!params[:band_city_name].blank?)
          city = City.find_by_fullname(params[:band_city_name]) || City.order(:name).where("LOWER(name) like ?", "#{params[:band_city_name].downcase}%").limit(1).first
          if city.present?
            params[:band][:city_id] = city.id
          else
            #no city update
          end
        else
          #no city update
        end
      end
    elsif(params[:section]=='members')
      band_has_owner = false
      new_members = []
      params[:band][:memberships_attributes].each do |key, membership|
        if membership["id"]
          if membership["_destroy"] == "1"
            authorize! :destroy, @band.memberships.find(membership["id"])
          else
            if membership["role"] != @band.memberships.find(membership["id"]).role
              case membership["role"]
              when "member"
                authorize! :convert_to_member, @band.memberships.find(membership["id"])
              when "manager"
                authorize! :convert_to_manager, @band.memberships.find(membership["id"])
              when "owner"
                authorize! :convert_to_owner, @band.memberships.find(membership["id"])
              when "invited"
                if membership["user_id"].to_i < 1
                  params['band']['memberships_attributes'][key]['role'] = "open"
                  membership["role"] = "open"
                end
              end
            end
            band_has_owner ||= (membership["role"]=="owner")
          end
        else
          authorize! :create, Membership
          new_member_id = membership["user_id"]
          if new_member_id.to_i > 0
            params['band']['memberships_attributes'][key]['role'] = "invited"
            new_members.push(new_member_id)
          else
            params['band']['memberships_attributes'][key]['role'] = "open"
            membership["role"] = "open"
          end
        end
      end
      @band.errors.add(:base, "You must designate at least one Owner") unless band_has_owner
    end

    if @band.errors.empty? && @band.update_attributes(params[:band])
      #send invitation from curent_user to new_members
      if (params[:section]=='members')
        new_members.each do |new_member|
          invitation = Message.new
          invitation.sender = current_user
          invitation.recipient_id = new_member
          invitation.subject = invitation.sender.name + " has invited you to join '" + @band.name + "' !"
          invitation.inviting_band_id = @band.id
          invitation.save
        end
      end
      flash.now[:success] = "Band data updated"
      render 'show'
    else
      render 'edit'
    end
  end

end
