namespace :db do
  desc "Fill database with sample users"
  task makesampleusers: :environment do

    User.delete_all
    Skill.delete_all
    Membership.delete_all
    roles = ['invited','member','manager','owner']

    user = User.create!(firstname: "Example",
                 surname: "User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    #user.city_id = rand(City.first.id..City.last.id)
    user.city_id = rrand(City.first.id, City.last.id)
    user.save

    n_skills = 0
    5.times do |n|
      begin
        n_skills = n_skills + 1
        user.skills.create(
          instrument_id: rrand(Instrument.first.id, Instrument.last.id), 
          priority: n_skills,
          expertise: rrand(1,3),#rand(1..3),
          experience: rrand(1,5),#rand(1..5),
          education: rrand(0,4)#rand(0..4)
        )
      rescue ActiveRecord::RecordNotUnique => exception
        n_skills = n_skills - 1
      end
    end

    Membership.create!(user_id: user.id, 
      band_id: rrand(Band.first.id, Band.last.id),
      instrument_id: user.skills[rrand(0,user.skills.count-1)].instrument_id,
      role: roles[rrand(0,roles.count-1)]
    )

    user = User.create!(firstname: "Olivier",
                 surname: "van den Biggelaar",
                 email: "ovdbigge@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    #user.city_id = rand(City.first.id..City.last.id)
    user.city_id = rrand(City.first.id, City.last.id)
    user.save

    n_skills = 0
    5.times do |n|
      begin
        n_skills = n_skills + 1
        user.skills.create(
          instrument_id: rrand(Instrument.first.id, Instrument.last.id), 
          priority: n_skills,
          expertise: rrand(1,3),#rand(1..3),
          experience: rrand(1,5),#rand(1..5),
          education: rrand(0,4)#rand(0..4)
        )
      rescue ActiveRecord::RecordNotUnique => exception
        n_skills = n_skills - 1
      end
    end

    for i in Band.first.id..Band.last.id
      Membership.create!(user_id: user.id, 
        band_id: i,
        instrument_id: user.skills[rrand(0,user.skills.count-1)].instrument_id,
        role: roles[rrand(0,roles.count-1)]
      )
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
      user.city_id = rrand(City.first.id, City.last.id)
      user.save
      
      n_skills = 0
      (rrand(1,2)+rrand(0,1)*rrand(0,1)).times do |n|
        begin
          n_skills = n_skills + 1
          user.skills.create(
            instrument_id: rrand(Instrument.first.id, Instrument.last.id), 
            priority: n_skills,
            expertise: rrand(1, 3),
            experience: rrand(1, 5),
            education: rrand(0,1)*rrand(0,2)*rrand(0,2))
        rescue ActiveRecord::RecordNotUnique => exception
          n_skills = n_skills - 1
        end
      end

      Membership.create!(user_id: user.id, 
        band_id: rrand(Band.first.id, Band.last.id),
        instrument_id: user.skills[rrand(0,user.skills.count-1)].instrument_id,
        role: roles[rrand(0,roles.count-1)]
      )

    end
  end
end

def rrand(start, finish)
  start + rand(1 + finish - start)
end