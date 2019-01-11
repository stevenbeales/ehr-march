FactoryGirl.define do
  factory :practice do
    provider_id              { nil }
    first_name               { Faker::Name.first_name }
    last_name                { Faker::Name.last_name  }
    association              :user, role: :Provider
    street_address           { Faker::Address.street_name }
    suit_apt_number          { Faker::Address.building_number }
    city                     { Faker::Address.city }
    state                    { State.sample.try(:id) }
    practice_street_address  { Faker::Address.street_name }
    practice_suit_apt_number { Faker::Address.building_number }
    practice_city            { Faker::Address.city }
    practice_state           { State.sample.try(:id) }
    practice_role            { Practice.practice_roles.sample }
    admin                    { false }
  end
end
