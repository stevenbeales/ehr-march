FactoryGirl.define do
  factory :insurance do
    association          :patient
    worker_compensation  { true }
    insurance_number     { (1..9).map{"123456789".chars.to_a.sample}.join }
    relation             { Insurance.relations.sample }
    effective_from       { Time.now }
    effective_to         { Time.now }
    copay_type           { Insurance.copay_types.sample }
    copay_amount         { Faker::Number.decimal(2) }
    claim                { Faker::Number.number(3) }
    note                 { Faker::Lorem.sentence }
    active               { true }
  end
end
