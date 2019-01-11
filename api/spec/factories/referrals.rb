FactoryGirl.define do
  factory :referral do
    normal          { Faker::Name.first_name }
    middle_name     { Faker::Name.first_name }
    last_name       { Faker::Name.last_name }
    individual_npi  { Faker::Company.ein }
    speciality      { Referral.specialities.sample }
    phone           { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    fax             { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    email           { Faker::Internet.email }
  end
end
