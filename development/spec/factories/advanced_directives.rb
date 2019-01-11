FactoryGirl.define do
  factory :advanced_directive do
    association    :patient
    record_date    { Time.now }
    notes          { nil }
  end
end
