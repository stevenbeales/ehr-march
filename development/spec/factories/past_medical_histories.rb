FactoryGirl.define do
  factory :past_medical_history do
    association             :patient
    major_events            { Faker::Lorem.sentence }
    ongoing_problems        { Faker::Lorem.sentence }
    preventitive_care       { Faker::Lorem.sentence }
    nutrition_history       { Faker::Lorem.sentence }
    developmental_history   { Faker::Lorem.sentence }
  end
end
