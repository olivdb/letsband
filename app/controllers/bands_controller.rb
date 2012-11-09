class BandsController < ApplicationController
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
  end

  def show
  	@band = Band.find(params[:id])
  end
end
