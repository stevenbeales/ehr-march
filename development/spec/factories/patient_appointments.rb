FactoryGirl.define do
  factory :patient_appointment do
    provider_id  { nil }
    patient_id   { nil }
    date         { Faker::Date.backward(30).to_time }
    location     { Faker::Address.street_name }
    appointment_type { PatientAppointment.appointment_types.sample }
    note         { Faker::Lorem.sentence }
    phone        { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    email        { Faker::Internet.email }
  end
end
