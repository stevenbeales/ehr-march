FactoryGirl.define do
  factory :appointment_type do
    appt_type   { AppointmentType.examples.sample }
    colour      { Activation.colour }
    association :provider
  end
end
