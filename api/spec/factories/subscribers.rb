FactoryGirl.define do
  factory :subscriber do
    association     :insurance
    first_name       { Faker::Name.first_name }
    middle_name      { Faker::Name.first_name }
    last_name        { Faker::Name.last_name }
    birth            { Time.now }
    gender           { Subscriber.genders.sample }
    social_number    { (1..9).map{"123456789".chars.to_a.sample}.join }
    phone            { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    street_address   { Faker::Address.street_address }
    city             { Zipcode.sample.city }
    state            { State.sample.name }
    zip              { Zipcode.sample.code.to_i }
  end
end
