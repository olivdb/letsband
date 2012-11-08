require 'open-uri'

namespace :db do
	desc "import csv files about city and region data and txt file about country data 
	and populates the 'cities', 'regions' and 'countries' tables of the db"

	task importcities: :environment do

		make_countries
		make_regions	

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
				if !country_code.blank?
					country = Country.find_by_code(country_code) || Country.create!(name: nil, code: country_code)
				else
					country = nil
				end
				region_code = attributes["region"].gsub('"','')
				if !region_code.blank?
					region = Region.find_by_code_and_country_id(region_code, country.id) || Region.create(name: nil, code: region_code, country_id: country.id)
				else
					region = nil
				end
				begin
					City.create!(name: city_name, country_id: country.nil? ? nil : country.id, region_id: region.nil? ? nil : region.id, longitude: longitude, latitude: latitude)
				rescue ActiveRecord::RecordNotUnique => exception
					#puts 'City "' + city_name + '" has already been added to db and has therefore been skipped.'
					next
				end
				
			end
			
		end
	end
end

def make_countries
	local_path = 'lib/tasks/citydata/'
	remote_path = 'http://www.iso.org/iso/'
	filename = 'list-en1-semic-3.txt'

	path = (File.exist?(local_path + filename) ? local_path : remote_path) + filename
	lines = open(path) { |f| f.readlines }
	lines.shift # remove header
	lines.each do |line|
		values = line.strip.split(';')
		Country.create!(name: values[0], code: values[1]) unless values[0].blank?
	end
end

def make_regions	
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
		country = Country.find_by_code(country_code)
		Region.create!(name: region_name, code: region_code, country_id: country.id) unless region_name.blank?
	end
end