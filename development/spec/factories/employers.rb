FactoryGirl.define do
  factory :employer do
    association     :insurance
    name            { Faker::Name.first_name }
    phone           { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    street_address  { Faker::Address.street_address }
    city            { Zipcode.sample.city }
    state           { State.sample.name }
    zip             { Zipcode.sample.code.to_i }
  end
end
