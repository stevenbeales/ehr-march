require 'api_documentation_helper'

RSpec.resource 'Patient appointment' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/patient_appointments' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient  }

    parameter :auth_token,       'Authentication Token',                                 required: true
    parameter :provider_id,      'Provider id',           scope: :patient_appointment,   required: true
    parameter :patient_id,       'Patient id',            scope: :patient_appointment,   required: true
    parameter :date,             'Appointment date',      scope: :patient_appointment
    parameter :location,         'Location',              scope: :patient_appointment
    parameter :appointment_type, 'Appointment type',      scope: :patient_appointment
    parameter :note,             'Note',                  scope: :patient_appointment
    parameter :phone,            'Provider phone',        scope: :patient_appointment
    parameter :email,            'Provider email',        scope: :patient_appointment

    let(:auth_token)       { patient.user.auth_token }
    let(:provider_id)      { provider.id }
    let(:patient_id)       { patient.id  }
    let(:date)             { Time.now }
    let(:location)         { provider.location1 }
    let(:appointment_type) { create(:appointment_type).appt_type }
    let(:note)             { Faker::Lorem.paragraph }
    let(:phone)            { Faker::PhoneNumber.phone_number }
    let(:email)            { Faker::Internet.email }

    example_request 'Create patient appointment' do
      expect(status).to eq 200
    end
  end
end