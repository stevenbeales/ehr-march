FactoryGirl.define do
  factory :vital do
    association    :encounter
    height_major   { Faker::Number.number(1) }
    height_minor   { Faker::Number.number(1) }
    units_system   { Vital.units_systems.sample }
    weight         { Faker::Number.number(2) }
    bp_left        { Faker::Lorem.word }
    bp_right       { Faker::Lorem.word }
    temp           { Faker::Lorem.word }
    pulse          { Faker::Lorem.word }
    rr             { Faker::Lorem.word }
    sat            { Faker::Lorem.word }
    temp_type      { Vital.temp_types.sample }
    ra_type        { Vital.ra_types.sample }
    blood          { Faker::Lorem.word }
  end
end
