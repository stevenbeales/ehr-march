FactoryGirl.define do
  factory :schedule_general do
    slot_size              { 30 }
    past_apps              { true }
    calendar_from          { '10:00:00'.to_time }
    calendar_to            { '19:00:00'.to_time }
    outside_practice_hour  { true }
    multiple_apps          { true }
    reschedule_for_patient { true }
    reschedule_time        { 24 }
  end

end
