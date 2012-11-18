class Band < ActiveRecord::Base
  attr_accessible :city_id, :description, :genre_id, :name, :image_name, :image, :memberships_attributes
  has_attached_file :image, :styles => { :medium => ["300x300>", :png] , :medium_2x => ["600x600>", :png], :thumb => ["100x100>", :png], :thumb_2x => ["200x200>", :png] }, :default_url => "/assets/bands/default_:style_band.png"

  belongs_to :city
  belongs_to :genre
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :instruments, through: :memberships

  accepts_nested_attributes_for :memberships, allow_destroy: true

  validates :name, presence: true
  validates_attachment :image,
    :content_type => { :content_type => ['image/jpg', 'image/jpeg', 'image/png'] }, 
    :size => { :less_than => 5.megabytes }

  def members
    User.find(memberships.where('role not in (?) ', ['invited', 'open']).map(&:user_id))
  end

  def self.get_filtered(params)
    city = City.find_by_id(params[:band_city_id])
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
