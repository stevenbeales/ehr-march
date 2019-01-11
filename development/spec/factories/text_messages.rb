FactoryGirl.define do
  factory :text_message do
    association :provider
    association :patient
    to          { Faker::Internet.email }
    from        { Faker::Internet.email }
    body        { Faker::Lorem.paragraph }
  end
end
