class BandsController < ApplicationController
  def index
  	@bands = Band.get_filtered(params)
  end

  def show
  	@band = Band.find(params[:id])
  end
end
