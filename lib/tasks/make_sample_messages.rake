namespace :db do
  desc "Fill database with sample users"
  task makesamplemessages: :environment do

    User.all.each do |sender|
      User.all.each do |recipient|
        m = Message.new
        m.sender = sender
        m.recipient = recipient
        m.subject = Faker::Lorem.sentence(rrand(4,10))
        m.body = Faker::Lorem.paragraphs(rrand(3,10))
        m.save
        if rand<0.05
          m = Message.read_message(m.id, recipient)
        end
      end
    end
  end
end


def rrand(start, finish)
  start + rand(1 + finish - start)
end