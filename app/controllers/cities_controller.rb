class CitiesController < ApplicationController
	def index
		@cities = City.order(:name).where("LOWER(name) like ?", "#{params[:term].downcase}%").limit(5)
		render json: @cities.map {|c| Hash[id: c.id, label: c.fullname, name: c.fullname]}
	end
end
