FactoryGirl.define do
  factory :user do
    sequence(:firstname) { |n| "Random" }
    sequence(:surname) { |n| "Guy #{n}" }
    sequence(:email) { |n| "random_guy_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :instrument do
  	sequence(:name) { |n| "Instrument #{n}" }
  end

  factory :city do
    sequence(:name) { |n| "City #{n}" }
  end
end