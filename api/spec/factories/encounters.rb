FactoryGirl.define do
  factory :encounter do
    association        :patient
    notes              { Faker::Lorem.sentence }
    med_completed      { true }
    patient_education  { true }
    clinical_summary   { true }
    to_provider_id     { nil }
    from_provider_id   { nil }
  end
end
