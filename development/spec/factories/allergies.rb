FactoryGirl.define do
  factory :allergy do
    association       :patient
    allergen_type     { Allergy.allergen_types.first }
    severity_level    { Allergy.severity_levels.first }
    onset_at          { Allergy.onset_ats.first }
    start_date        { Time.now }
    active            { true }
    note              { Faker::Lorem.sentence }
  end
end
