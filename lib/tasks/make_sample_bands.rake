namespace :db do
  desc "Fill database with sample bands"
  task makesamplebands: :environment do

    Band.delete_all

    30.times do |n|
      band = Band.create!(name: Faker::Company.name,
        genre_id: rrand(Genre.first.id, Genre.last.id),
        city_id: rrand(City.first.id, City.last.id),
        description: Faker::Lorem.paragraphs(rrand(1,6))
      )
    end

  end
end

def rrand(start, finish)
  start + rand(1 + finish - start)
end