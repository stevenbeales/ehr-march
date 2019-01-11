FactoryGirl.define do
  factory :timeslot do
    location_id   { nil }
    weekday       { Timeslot.weekdays.sample }
    from          { Time.now.beginning_of_day + 15.minutes * (0..45).to_a.sample }
    to            { Time.now.beginning_of_day + 15.minutes * (46..95).to_a.sample }
    specific_hour { Timeslot.specific_hours.sample }
  end
end
