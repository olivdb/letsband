class Band < ActiveRecord::Base
  MEDIUM_IMAGE_RESOLUTION="300x300"
  MEDIUM_2X_IMAGE_RESOLUTION="600x600"
  THUMB_IMAGE_RESOLUTION="100x100"
  THUMB_2X_IMAGE_RESOLUTION="200X200"

  attr_accessible :city_id, :description, :genre_id, :name, :image, :memberships_attributes
  has_attached_file :image, :styles => { :medium => [MEDIUM_IMAGE_RESOLUTION+">", :png] , :medium_2x => [MEDIUM_2X_IMAGE_RESOLUTION+">", :png], :thumb => [THUMB_IMAGE_RESOLUTION+">", :png], :thumb_2x => [THUMB_2X_IMAGE_RESOLUTION+">", :png] }, :default_url => "/assets/bands/:style/default_band.png"
  after_post_process :save_image_dimensions

  belongs_to :city
  belongs_to :genre
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :instruments, through: :memberships

  accepts_nested_attributes_for :memberships, allow_destroy: true

  validates :name, presence: true, length: { maximum: 100 }
  validates_attachment :image,
    :content_type => { :content_type => ['image/jpg', 'image/jpeg', 'image/png'] }, 
    :size => { :less_than => 1.megabytes }

  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(image.queued_for_write[:original])
    self.image_width = geo.width
    self.image_height = geo.height
  end

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

      selected_position = {}
      if params[:only_open_position]
        if params[:selected_position].to_i >= 1
          selected_position = { memberships: { role: "open", instrument_id: params[:selected_position] } }
        else
          selected_position = { memberships: { role: "open" } }
        end
      end

      selected_activity_period = ''
      if params[:only_active]
        #selected_activity_period = { bands: { updated_at: params[:selected_activity_period].to_i.months.ago..Time.now } }
        #selected_activity_period = "bands.updated_at > :oldest_date_acceptable or users.last_seen_at > :oldest_date_acceptable"
        selected_activity_period = "users.last_seen_at > :oldest_date_acceptable"
      end

      selected_genre = {}
      if params[:genre_id].to_i >=1
        selected_genre = { bands: { genre_id: params[:genre_id] } }
      end

      Band.select("bands.*, (#{lat}-cities.latitude)*(#{lat}-cities.latitude) + (#{lon}-cities.longitude)*(#{lon}-cities.longitude) AS distance")
          .includes(:city)
          .joins('INNER JOIN cities ON bands.city_id = cities.id')
          .joins('INNER JOIN memberships ON bands.id = memberships.band_id')
          .joins('INNER JOIN memberships AS user_m ON bands.id = user_m.band_id')
          .joins('INNER JOIN users on users.id = user_m.user_id')
          .where(cities: { country_id: city.country_id, latitude: lat1..lat2, longitude: lon1..lon2 })
          .where(selected_position)
          .where(selected_activity_period, { oldest_date_acceptable: params[:selected_activity_period].to_i.months.ago })
          .where(selected_genre)
          .order("distance ASC")
          .uniq
          .map{ |b| b }
          .paginate(page: params[:page], per_page: 10)

    else
      Band.where('NULL').paginate(page: params[:page])
    end
  end

end
