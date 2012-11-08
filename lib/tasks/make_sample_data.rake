namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    Rake::Task['db:reset'].invoke
    Rake::Task['db:importcitieslight'].invoke
    Rake::Task['db:importinstruments'].invoke
 	Rake::Task['db:importgenres'].invoke
    Rake::Task['db:makesampleusers'].invoke
  end
end