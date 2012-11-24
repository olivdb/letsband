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
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable #:database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :firstname, :surname, :password, :password_confirmation, :city_id, :skills_attributes, :favorite_genres_attributes
  attr_accessor :updating_password
  has_secure_password
  has_private_messages

  belongs_to :city
  has_many :contact_records, :foreign_key => :owner_id, dependent: :destroy
  has_many :contacts, :through => :contact_records, :class_name => "User"
  has_many :memberships, dependent: :destroy
  has_many :bands, through: :memberships
  has_many :skills, dependent: :destroy, order: 'priority ASC'
  has_many :favorite_genres, dependent: :destroy
  has_many :instruments, through: :skills  
  has_many :genres, through: :favorite_genres

  accepts_nested_attributes_for :skills, allow_destroy: true
  accepts_nested_attributes_for :favorite_genres, allow_destroy: true

  validates :firstname, presence: true, length: { maximum: 20 }
  validates :surname, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  				    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, :if => :should_validate_password?
  validates :password_confirmation, presence: true, :if => :should_validate_password?

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token


  def reset_confirmation
    self.confirmed_at = nil
    self.confirmation_sent_at = nil
    self.confirmation_token = nil
    self.unconfirmed_email = nil
    save
  end

  def should_validate_password?
    updating_password || new_record?
  end

  def name
    self.firstname + ' ' + self.surname
  end

  def self.get_filtered(params)
    city = City.find_by_id(params[:user_city_id])
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

      selected_city = { cities: { country_id: city.country_id, latitude: lat1..lat2, longitude: lon1..lon2 } }
      select = "users.*, (#{lat}-cities.latitude)*(#{lat}-cities.latitude) + (#{lon}-cities.longitude)*(#{lon}-cities.longitude) AS distance"
      order = "distance ASC"

      selected_instrument = {}
      if params[:instrument_id].to_i >=1
        selected_instrument = { skills: { instrument_id: params[:instrument_id] } }
      end

      user_name = {}
      if params[:only_user_name]
        user_name = "LOWER(users.firstname || ' ' || users.surname) like ?", "%#{params[:user_name].downcase}%"
      end

      selected_activity_period = {}
      if params[:only_active_users]
        selected_activity_period = { users: { last_seen_at: params[:selected_user_activity_period].to_i.months.ago..Time.now } }
      end

      selected_genre = {}
      if params[:only_looking_for_band]
        if params[:selected_genre].to_i >= 1
          selected_genre = { favorite_genres: { genre_id: [params[:selected_genre], Genre.find_by_name("Unknown").try(:id)].delete_if{|g|g.nil?}, looking_for_band: true } }
        else
          selected_genre = { favorite_genres: { looking_for_band: true } }
        end
      end

      User.select(select)
          .includes(:city)
          .joins('LEFT JOIN skills ON skills.user_id = users.id')
          .joins('LEFT JOIN favorite_genres ON favorite_genres.user_id = users.id')
          .joins('INNER JOIN cities ON users.city_id = cities.id')
          .where(selected_city)
          .where(selected_instrument)
          .where(user_name)
          .where(selected_activity_period)
          .where(selected_genre)
          .order(order)
          .uniq
          .map{ |u| u }
          .paginate(page: params[:page], per_page: 10)

    else
      User.where('NULL').paginate(page: params[:page])
    end
  end

  def invite!(invited_user, band, invitation_text)
    invited_user.memberships.create!(band_id: band.id, role: "invited")  
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
