FactoryGirl.define do
  factory :appointment_status do
    name   { AppointmentStatus.examples.sample }
    colour { Activation.colour }
    association :provider
  end
end
