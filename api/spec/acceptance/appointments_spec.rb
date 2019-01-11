require 'api_documentation_helper'

RSpec.resource 'Appointments' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/appointments/new' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token',       scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'New appointment' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['type']).to eq 'appointments'
    end
  end

  post '/appointments' do
    before do
      User.destroy_all
      Appointment.destroy_all
      EmailMessage.destroy_all
      Room.destroy_all
      AppointmentType.destroy_all
      AppointmentStatus.destroy_all
      Referral.destroy_all
    end

    let!(:provider)    { create :provider }
    let!(:appointment) { create :appointment }
    let!(:referral)    { create :referral }

    parameter :auth_token,                'Authentication Token',                         required: true
    parameter :patient_id,                'Patient id',            scope: :appointment,   required: true
    parameter :location,                  'Location',              scope: :appointment,   required: true
    parameter :room_id,                   'Room id',               scope: :appointment,   required: true
    parameter :appointment_type_id,       'Appointment type id',   scope: :appointment,   required: true
    parameter :appointment_datetime,      'Appointment datetime',  scope: :appointment,   required: true
    parameter :reason,                    'Reason',                scope: :appointment,   required: true
    parameter :duration,                  'Duration',              scope: :appointment,   required: true
    parameter :contact_email,             'Patient contact email', scope: :appointment,   required: true
    parameter :contact_phone,             'Patient contact phone', scope: :appointment,   required: true
    parameter :reminder,                  'Reminder',              scope: :appointment
    parameter :colour,                    'Colour',                scope: :appointment
    parameter :referral_id,               'Referral id',           scope: :appointment,   required: true

    let(:auth_token)                { provider.user.auth_token }
    let(:patient_id)                { appointment.patient_id }
    let(:location)                  { appointment.location }
    let(:room_id)                   { appointment.room_id }
    let(:appointment_type_id)       { appointment.appointment_type_id }
    let(:appointment_datetime)      { appointment.appointment_datetime }
    let(:reason)                    { appointment.reason }
    let(:duration)                  { appointment.duration }
    let(:contact_email)             { appointment.contact_phone }
    let(:contact_phone)             { appointment.contact_phone }
    let(:reminder)                  { appointment.reminder }
    let(:colour)                    { appointment.colour }
    let(:referral_id)               { referral.id }

    example_request 'Create appointment' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Appointment.last).to_json
    end
  end

  patch '/appointments/:id' do
    before do
      User.destroy_all
      Appointment.destroy_all
      Room.destroy_all
      AppointmentType.destroy_all
      AppointmentStatus.destroy_all
      Referral.destroy_all
    end

    let!(:provider)        { create :provider }
    let!(:appointment)     { create :appointment }
    let!(:old_appointment) { create :appointment }
    let!(:referral)        { create :referral }
    let!(:old_referral)    { create :referral }

    parameter :auth_token,                'Authentication Token',                         required: true
    parameter :id,                        'Appointment id',                               required: true
    parameter :patient_id,                'Patient id',            scope: :appointment
    parameter :location,                  'Location',              scope: :appointment
    parameter :room_id,                   'Room id',               scope: :appointment
    parameter :appointment_type_id,       'Appointment type id',   scope: :appointment
    parameter :reason,                    'Reason',                scope: :appointment
    parameter :duration,                  'Duration',              scope: :appointment
    parameter :contact_email,             'Patient contact email', scope: :appointment
    parameter :contact_phone,             'Patient contact phone', scope: :appointment
    parameter :reminder,                  'Reminder',              scope: :appointment
    parameter :colour,                    'Colour',                scope: :appointment
    parameter :referral_id,               'Referral id',           scope: :appointment
    parameter :normal,                    'Referral normal',       scope: :referral
    parameter :middle_name,               'Referral middle name',  scope: :referral
    parameter :last_name,                 'Referral last name',    scope: :referral
    parameter :individual_npi,            'Referral npi',          scope: :referral
    parameter :speciality,                'Referral speciality',   scope: :referral
    parameter :phone,                     'Referral phone',        scope: :referral
    parameter :fax,                       'Referral fax',          scope: :referral
    parameter :email,                     'Referral email',        scope: :referral

    let(:auth_token)                { provider.user.auth_token }
    let(:id)                        { old_appointment.id }
    let(:patient_id)                { appointment.patient_id }
    let(:location)                  { appointment.location }
    let(:room_id)                   { appointment.room_id }
    let(:appointment_type_id)       { appointment.appointment_type_id }
    let(:reason)                    { appointment.reason }
    let(:duration)                  { appointment.duration }
    let(:contact_email)             { appointment.contact_phone }
    let(:contact_phone)             { appointment.contact_phone }
    let(:reminder)                  { appointment.reminder }
    let(:colour)                    { appointment.colour }
    let(:referral_id)               { old_referral.id }
    let(:normal)                    { referral.normal }
    let(:middle_name)               { referral.middle_name }
    let(:last_name)                 { referral.last_name }
    let(:individual_npi)            { referral.individual_npi }
    let(:speciality)                { referral.speciality }
    let(:phone)                     { referral.phone }
    let(:fax)                       { referral.fax }
    let(:email)                     { referral.email }

    example_request 'Update appointment' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Appointment.find(old_appointment.id)).to_json
    end
  end

  get '/appointments/:id' do
    before do
      User.destroy_all
      Appointment.destroy_all
      Room.destroy_all
      AppointmentType.destroy_all
      AppointmentStatus.destroy_all
    end

    let!(:provider)    { create :provider }
    let!(:appointment) { create :appointment }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Appointment id',       scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { appointment.id }

    example_request 'Show appointment' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Appointment.first).to_json
    end
  end

  delete '/appointments/:id' do
    before do
      User.destroy_all
      Appointment.destroy_all
      Room.destroy_all
      AppointmentType.destroy_all
      AppointmentStatus.destroy_all
    end

    let!(:user)        { create(:provider).user }
    let!(:appointment) { create :appointment }

    parameter :auth_token, 'Authentication Token',   required: true
    parameter :id,         'Appointment id',         required: true

    let(:auth_token) { user.auth_token }
    let(:id)         { appointment.id }

    example_request 'Delete appointment' do
      expect(status).to eq 200
    end
  end

  get '/appointments/patients' do
    before do
      User.destroy_all
    end
    let!(:provider) { create :provider }
    let!(:patient1) { create :patient, first_name: 'Den', last_name: 'Brown',    provider_id: provider.id }
    let!(:patient2) { create :patient, first_name: 'Den', last_name: 'Crown',    provider_id: provider.id }
    let!(:patient3) { create :patient, first_name: 'Den', last_name: 'Down',     provider_id: provider.id }
    let!(:patient4) { create :patient, first_name: 'Den', last_name: 'Xown',     provider_id: provider.id }
    let!(:patient5) { create :patient, first_name: 'Den', last_name: 'Unknown',  provider_id: provider.id }

    parameter :auth_token, 'Authentication Token',                            scope: :data,   required: true
    parameter :part,       "The beginning of a patient's first or last name", scope: :data

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'De' }

    example_request 'Find patients by part of first or last name' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Patient.all, is_collection: true).to_json
    end
  end

  get '/appointments/patients' do
    before do
      User.destroy_all
    end
    let!(:provider) { create :provider }
    let!(:patients)  { 10.times { create :patient, provider_id: provider.id } }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Get first 10 patients' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Patient.all, is_collection: true).to_json
    end
  end

  get '/appointments/referrals' do
    before do
      User.destroy_all
      Referral.destroy_all
      provider = create :provider
      create(:referral, normal: 'Den', last_name: 'Brown',   provider_id: provider.id)
      create(:referral, normal: 'Den', last_name: 'Crown',   provider_id: provider.id)
      create(:referral, normal: 'Den', last_name: 'Down',    provider_id: provider.id)
      create(:referral, normal: 'Den', last_name: 'Xown',    provider_id: provider.id)
      create(:referral, normal: 'Den', last_name: 'Unknown', provider_id: provider.id)
    end
    let!(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',                              scope: :data,   required: true
    parameter :part,       "The beginning of a referral's normal or last name", scope: :data

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'De' }

    example_request 'Find referrals by part of normal or last name' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Referral.all, is_collection: true).to_json
    end
  end

  get '/appointments/referrals' do
    before do
      User.destroy_all
      Referral.destroy_all
    end
    let!(:provider)   { create :provider }
    let!(:referrals)  { 10.times { create :referral, provider_id: provider.id } }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Get first 10 referrals' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Referral.all, is_collection: true).to_json
    end
  end

  get '/appointments/reschedule' do
    before do
      User.destroy_all
    end
    let!(:provider)    { create :provider }
    let!(:appointment) { create :appointment }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Appointment id',       scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { appointment.id }

    example_request 'Set appointment status to reschedule' do
      expect(status).to eq 200
    end
  end
end