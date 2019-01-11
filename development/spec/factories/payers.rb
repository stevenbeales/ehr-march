FactoryGirl.define do
  factory :payer do
    association :patient
    name        { Faker::Name.first_name }
    plan        { Faker::Name.first_name }
    plan_type   { Payer.plan_types.sample }
  end
end
