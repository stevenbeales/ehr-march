FactoryGirl.define do
  factory :provider do
    first_name               { Faker::Name.first_name }
    last_name                { Faker::Name.last_name  }
    practice_role            { :Provider }
    association              :user, role: :Provider
    street_address           { Faker::Address.street_name }
    suit_apt_number          { Faker::Address.building_number }
    city                     { Faker::Address.city }
    state                    { State.sample.try(:name) }
    status                   { true }
    practice_street_address  { Faker::Address.street_name }
    practice_suit_apt_number { Faker::Address.building_number }
    practice_city            { Faker::Address.city }
    practice_state           { State.sample.try(:name) }
    profile_image            { File.open(Rails.root.join('app', 'assets', 'images', 'admin', "avatar#{(1..11).to_a.sample}.jpg")) }
  end
end
