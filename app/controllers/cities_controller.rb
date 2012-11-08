class CitiesController < ApplicationController
	def index
		@cities = City.order(:name).where("name like ?", "#{params[:term]}%").limit(5)
		render json: @cities.map {|c| Hash[id: c.id, label: c.fullname, name: c.fullname]}
	end
end
