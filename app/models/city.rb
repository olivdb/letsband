class City < ActiveRecord::Base
  attr_accessible :name, :country_id, :latitude, :longitude, :region_id

  has_many :users
  belongs_to :region
  belongs_to :country
  
  def fullname
  	name \
  	+ ((!region.nil? && !region.name.nil?) ? (', ' + region.name) : '') \
  	+ ((!country.nil? && !country.name.nil?) ? (', ' + country.name) : '')
  end

  def self.find_by_fullname(fullname)
  	if fullname.blank?
  		return nil
  	end
  	location = fullname.split(', ')
  	cityname = location.first
  	if location.length > 1
  		countryname = location.last
  	end
  	if location.length == 3
  		regionname = location[1]
  	end
  	query = 'SELECT ci.* FROM cities AS ci, countries AS co, regions AS re 
  		WHERE ci.name = ?'
  	if regionname.present?
  		query += ' AND ci.region_id = re.id AND re.name = ? AND ci.country_id = co.id AND co.name = ?'
  		city = City.find_by_sql([query, cityname, regionname, countryname]).first
  	elsif countryname.present?
  		query += ' AND ci.country_id = co.id AND co.name = ?'
  		city = City.find_by_sql([query, cityname, countryname]).first
  	else
  		city = City.find_by_sql([query, cityname]).first
  	end
  end

  def distance(other_city)
  	#3956 * Math.hypot((self.latitude - other_city.latitude)/180*Math::PI, (self.longitude - other_city.longitude)/180*Math::PI)

  	3956 * 2 * Math.asin(Math.sqrt( (Math.sin((self.latitude - other_city.latitude) *  Math::PI/180 / 2) ** 2) + Math.cos(self.latitude * Math::PI/180) * Math.cos(other_city.latitude * Math::PI/180) * (Math.sin((self.longitude - other_city.longitude) * Math::PI/180 / 2)** 2) ))

  end
end
