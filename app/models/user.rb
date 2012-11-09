# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  surname    :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :firstname, :surname, :password, :password_confirmation
  has_secure_password

  belongs_to :city
  has_many :memberships, dependent: :destroy
  has_many :bands, through: :memberships
  has_many :skills, dependent: :destroy, order: 'priority ASC'
  has_many :instruments, through: :skills  

  validates :firstname, presence: true, length: { maximum: 20 }
  validates :surname, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  				    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  def name
    self.firstname + ' ' + self.surname
  end

  def self.get_filtered(params)
    #city = City.find_by_fullname(params[:city_name])
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

      User.includes(:city)
          .joins(:skills)
          .joins('INNER JOIN cities ON users.city_id = cities.id')
          .where(cities: { country_id: city.country_id, latitude: lat1..lat2, longitude: lon1..lon2 }, skills: { instrument_id: params[:instrument_id] })
          .order("(#{lat}-cities.latitude)*(#{lat}-cities.latitude) + (#{lon}-cities.longitude)*(#{lon}-cities.longitude) ASC")
          .paginate(page: params[:page], per_page: 50)

    else
      User.where('NULL').paginate(page: params[:page])
    end
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
