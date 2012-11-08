namespace :db do
	desc "populates the 'instruments' table of the db"

	task importinstruments: :environment do
		Instrument.delete_all
		path = 'lib/tasks/instrumentdata/instrument_list_light.txt'
		lines = open(path) { |f| f.readlines }
		lines.each do |line|
			instrument_name = line.strip
			if !instrument_name.blank?
				Instrument.create!(name: instrument_name)
			end
		end
	end
end
