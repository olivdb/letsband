class CitiesController < ApplicationController
	def index
		@cities = City.order(:name).where("name like lower(?)", "#{params[:term].lower}%").limit(5)
		render json: @cities.map {|c| Hash[id: c.id, label: c.fullname, name: c.fullname]}
	end
end
