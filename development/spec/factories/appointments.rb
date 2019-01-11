FactoryGirl.define do
  factory :appointment do
    association           :patient
    association           :provider
    location              { Faker::Address.street_address }
    association           :room
    association           :appointment_type
    association           :appointment_status
    appointment_datetime  { Time.now }
    reason                { Faker::Lorem.sentence }
    duration              { Appointment.durations.sample }
    contact_email         { Faker::Internet.email }
    contact_phone         { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    reminder              { [true, false].sample }
    colour                { Activation.colour }
  end
end
