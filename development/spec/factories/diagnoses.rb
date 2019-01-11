FactoryGirl.define do
  factory :diagnosis do
    association       :patient
    diagnosis_code_id { DiagnosisCode.sample.try(:id) }
    start_date        { Time.now - 1.hour }
    stop_date         { Time.now + 1.hour }
    acute             { true }
    terminal          { true }
    note              { Faker::Hipster.sentence }
  end
end
