FactoryGirl.define do
  factory :subject do
    name { Faker::Lorem.word.capitalize }
  end
end
