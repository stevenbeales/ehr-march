FactoryGirl.define do
  factory :smoking_status do
    association    :patient
    status         { SmokingStatus.statuses.sample }
    effective_from { Time.now }
  end
end
