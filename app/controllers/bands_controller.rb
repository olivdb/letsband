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
      update_location
    elsif(params[:section]=='members')
      update_members
    else 
      update_presentation
    end        
  end

  private
    def update_presentation
      if @band.update_attributes(params[:band])
          flash.now[:success] = "Band presentation updated !"
          render 'show'
      else
        render 'edit'
      end
    end
    def update_location
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
      if @band.update_attributes(params[:band])
          flash.now[:success] = "Band location updated !"
          render 'show'
      else
        render 'edit'
      end
    end

    def update_members
      band_has_owner = false
      params[:band][:memberships_attributes].each do |key, membership|
        if membership["id"]
          if membership["_destroy"] == "1"
            authorize! :destroy, @band.memberships.find(membership["id"])
          else
            if membership["role"] != @band.memberships.find(membership["id"]).role
              case membership["role"]
              when "member"
                authorize!(:convert_to_member, @band.memberships.find(membership["id"])) unless ((@band.memberships.find(membership["id"]).user_id == current_user.id) && (@band.memberships.find(membership["id"]).role == "owner"))
              when "manager"
                authorize!(:convert_to_manager, @band.memberships.find(membership["id"])) unless ((@band.memberships.find(membership["id"]).user_id == current_user.id) && (@band.memberships.find(membership["id"]).role == "owner"))
              when "owner"
                authorize! :convert_to_owner, @band.memberships.find(membership["id"])  
              when "invited"
                authorize! :convert_to_invited, @band.memberships.find(membership["id"])  
                #raise CanCan::AccessDenied.new("Action not authorized! >_<", :convert_to_invited, @band.memberships.find(membership["id"]).user_id)
              when "open"
                raise CanCan::AccessDenied.new("Action not authorized! -_-", :convert_to_open, @band.memberships.find(membership["id"]).user_id)
              end
            end
            if membership["instrument_id"].to_i != @band.memberships.find(membership["id"]).instrument_id
              authorize! :change_instrument, @band.memberships.find(membership["id"])
            end
            if (membership["user_id"].to_i != @band.memberships.find(membership["id"]).user_id) && @band.memberships.find(membership["id"]).user_id >= 1
              raise CanCan::AccessDenied.new("Action not authorized! O_O", :change_user, @band.memberships.find(membership["id"]).user_id)
            end
            band_has_owner ||= (membership["role"]=="owner")
          end
        else
          authorize!(:create, Membership.new(band_id: @band.id))
        end
      end
      @band.errors.add(:base, "You must designate at least one Owner") unless band_has_owner

      if @band.errors.empty? #&& @band.update_attributes(params[:band])
        params[:band][:memberships_attributes].each do |key, membership|
          hash = { :memberships_attributes => { '0' => membership } }
          if @band.update_attributes(hash)
            if !membership["id"] && membership["user_id"].to_i > 0
              invitation = Message.new
              invitation.sender = current_user
              invitation.recipient_id = membership["user_id"]
              invitation.subject = invitation.sender.name + " has invited you to join '" + @band.name + "' !"
              invitation.inviting_band_id = @band.id
              invitation.save
            end
          end
        end
      end

      if @band.errors.empty?
        flash.now[:success] = "Band members updated !"
        render 'show'
      else
        render 'edit'
      end
    end

    

end
