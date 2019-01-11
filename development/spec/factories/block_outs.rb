FactoryGirl.define do
  factory :block_out do
    association     :patient
    time_for        { BlockOut.time_fors.sample }
    block_datetime  { Time.now }
    duration        { BlockOut.durations.sample }
    description     { Faker::Lorem.sentence }
    note            { Faker::Lorem.sentence }
    recurring       { [true, false].sample }
    recur_every     { Faker::Lorem.word }
    range_day       { BlockOut.range_days.sample }
  end
end