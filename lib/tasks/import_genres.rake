namespace :db do
	desc "populates the 'genres' table of the db"

	task importgenres: :environment do
		Genre.delete_all
		path = 'lib/tasks/genredata/genre_list_light.txt'
		lines = open(path) { |f| f.readlines }
		lines.each do |line|
			genre_name = line.strip
			if !genre_name.blank?
				Genre.create!(name: genre_name)
			end
		end
	end
end
