class Band < ActiveRecord::Base
  attr_accessible :city_id, :description, :genre_id, :name

  belongs_to :city
  belongs_to :genre
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :instruments, through: :memberships

  def self.get_filtered(params)
    city = City.find_by_id(params[:city_id])
    if city.present?
      lon = city.longitude
      lat = city.latitude
      dmax = params[:radius]
      if dmax.blank?
        dmax = 100
      end
      dlon = dmax/(Math.cos(lat/180*Math::PI)*65.97).abs
      lon1 = lon - dlon
      lon2 = lon + dlon
      dlat = dmax/65.97
      lat1 = lat - dlat
      lat2 = lat + dlat

      Band.includes(:city)
          .joins('INNER JOIN cities ON bands.city_id = cities.id')
          .where(cities: { country_id: city.country_id, latitude: lat1..lat2, longitude: lon1..lon2 }, genre_id: params[:genre_id])
          .order("(#{lat}-cities.latitude)*(#{lat}-cities.latitude) + (#{lon}-cities.longitude)*(#{lon}-cities.longitude) ASC")
          .paginate(page: params[:page], per_page: 50)

    else
      Band.where('NULL').paginate(page: params[:page])
    end
  end

end
