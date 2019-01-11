FactoryGirl.define do
  factory :guarantor do
    association      :patient
    first_name       { Faker::Name.first_name }
    middle_name      { Faker::Name.first_name }
    last_name        { Faker::Name.last_name }
    birth            { Time.now }
    gender           { Guarantor.genders.sample }
    social_number    { (1..9).map{"123456789".chars.to_a.sample}.join }
    relation         { Guarantor.relations.sample }
    phone            { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    email            { Faker::Internet.email }
    street_address   { Faker::Address.street_address }
    city             { Zipcode.sample.city }
    state            { State.sample.name }
    zip              { Zipcode.sample.code.to_i }
  end
end