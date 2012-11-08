require 'open-uri'

namespace :dbold do
	desc "import csv files about city and region names and txt file about country names 
	and populates the 'cities' table of the db"

	task importcitiesold: :environment do

		country_hash = make_country_hash_old
		region_hash = make_region_hash_old

		local_path = 'lib/tasks/citydata/'
		remote_path = 'http://www.maxmind.com/'
		filename = 'GeoIPCity-534-Location.csv'

		path = (File.exist?(local_path + filename) ? local_path : remote_path) + filename
		lines = open(path, 'r:iso-8859-1') { |f| f.readlines }

		lines.shift(1) # remove first line
		header = lines.shift.strip
		keys = header.split(',')

		lines.each do |line|
			values = line.strip.split(',')
			attributes = Hash[keys.zip values]
			city_name = attributes["city"].gsub('"','')
			if !city_name.blank?
				longitude = attributes["longitude"]
				latitude = attributes["latitude"]
				country_code = attributes["country"].gsub('"','')
				region_code = attributes["region"].gsub('"','')
				region_name = region_hash[[country_code, region_code]]
				country_name = country_hash[country_code]
				City.create!(name: city_name, country: country_name, region: region_name, longitude: longitude, latitude: latitude)
			end
			
		end
	end
end

def make_country_hash_old
	country_hash = {}

	local_path = 'lib/tasks/citydata/'
	remote_path = 'http://www.iso.org/iso/'
	filename = 'list-en1-semic-3.txt'

	path = (File.exist?(local_path + filename) ? local_path : remote_path) + filename
	lines = open(path) { |f| f.readlines }
	lines.shift # remove header
	lines.each do |line|
		values = line.strip.split(';')
		country_hash[values[1]] = values[0] unless values[0].blank?
	end
	country_hash
end

def make_region_hash_old
	region_hash = {}
	
	local_path = 'lib/tasks/citydata/'
	remote_path = 'http://dev.maxmind.com/static/'
	filename = 'maxmind-region-codes.csv'

	path = (File.exist?(local_path + filename) ? local_path : remote_path) + filename
	lines = open(path) { |f| f.readlines }
	lines.each do |line|
		line.strip!
		country_code = line.slice(0,2)
		region_code = line.slice(3,2)
		region_name = line.slice(6,line.length).delete('"')
		region_hash[[country_code, region_code]] = region_name unless region_name.blank?
	end
	region_hash
end