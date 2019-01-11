FactoryGirl.define do
  factory :room do
    room        { Faker::Address.secondary_address }
    association :provider
  end
end
