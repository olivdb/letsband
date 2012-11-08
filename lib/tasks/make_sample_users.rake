namespace :db do
  desc "Fill database with sample users"
  task makesampleusers: :environment do

    User.delete_all
    Skill.delete_all

    user = User.create!(firstname: "Example",
                 surname: "User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    user.city_id = rand(City.first.id..City.last.id)
    user.save

    n_skills = 0
    5.times do |n|
      begin
        n_skills = n_skills + 1
        user.skills.create!(
          instrument_id: rand(Instrument.first.id..Instrument.last.id), 
          priority: n_skills,
          expertise: rand(1..3),
          experience: rand(1..5),
          education: rand(0..4))
      rescue ActiveRecord::RecordNotUnique => exception
        n_skills = n_skills - 1
      end
    end

    99.times do |n|
      firstname  = Faker::Name.first_name
      lastname  = Faker::Name.last_name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      user = User.create!(firstname: firstname,
                   surname: lastname,
                   email: email,
                   password: password,
                   password_confirmation: password)
      user.city_id = rand(City.first.id..City.last.id)
      user.save
      
      n_skills = 0
      (rand(1..2)+rand(0..1)*rand(0..1)).times do |n|
        begin
          n_skills = n_skills + 1
          user.skills.create!(
            instrument_id: rand(Instrument.first.id..Instrument.last.id), 
            priority: n_skills,
            expertise: rand(1..3),
            experience: rand(1..5),
            education: rand(0..1)*rand(0..2)*rand(0..2))
        rescue ActiveRecord::RecordNotUnique => exception
          n_skills = n_skills - 1
        end
      end
    end
  end
end