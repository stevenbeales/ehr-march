require 'api_documentation_helper'

RSpec.resource 'Patients' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/patients' do
    before do
      User.destroy_all
      Appointment.destroy_all
      patient = create :patient
      3.times { create :appointment, appointment_datetime: Time.now, patient_id: patient.id }
    end
    let(:patient) { Patient.first }

    parameter :auth_token,   'Authentication Token',   scope: :data,   required: true

    let(:auth_token)    { patient.user.auth_token }

    example_request 'Index' do
      expect(status).to        eq 200
      expect(JSON.parse(response_body)['data']['appointments'].count).to eq 3
      expect(JSON.parse(response_body)['data']['notifications'].present?).to eq true
    end
  end

  post '/patients' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token,            'Authentication Token',                   required: true
    parameter :email,                 'Email',                 scope: :user,    required: true
    parameter :password,              'Password',              scope: :user,    required: true
    parameter :password_confirmation, 'Password confirmation', scope: :user,    required: true
    parameter :first_name,            'First_name',            scope: :patient
    parameter :last_name,             'Last name',             scope: :patient
    parameter :middle_name,           'Middle name',           scope: :patient
    parameter :birth,                 'Birth date',            scope: :patient
    parameter :gender,                'Gender',                scope: :patient
    parameter :mobile_phone,          'Mobile phone',          scope: :patient
    parameter :primary_phone,         'Primary phone',         scope: :patient

    let(:auth_token)            { provider.user.auth_token }
    let(:email)                 { 'test@email.com' }
    let(:password)              { 'patient' }
    let(:password_confirmation) { 'patient' }
    let(:first_name)            { patient.first_name }
    let(:last_name)             { patient.last_name }
    let(:middle_name)           { patient.middle_name }
    let(:birth)                 { patient.birth }
    let(:gender)                { patient.gender }
    let(:mobile_phone)          { patient.mobile_phone }
    let(:primary_phone)         { patient.primary_phone }

    example_request 'Create new patient' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Patient.last).to_json
    end
  end

  post '/patients/simple_create' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token,            'Authentication Token',                      required: true
    parameter :first_name,            'First_name',            scope: :patient
    parameter :last_name,             'Last name',             scope: :patient
    parameter :middle_name,           'Middle name',           scope: :patient
    parameter :birth,                 'Birth date',            scope: :patient
    parameter :gender,                'Gender',                scope: :patient
    parameter :mobile_phone,          'Mobile phone',          scope: :patient
    parameter :primary_phone,         'Primary phone',         scope: :patient

    let(:auth_token)            { provider.user.auth_token }
    let(:first_name)            { patient.first_name }
    let(:last_name)             { patient.last_name }
    let(:middle_name)           { patient.middle_name }
    let(:birth)                 { patient.birth }
    let(:gender)                { patient.gender }
    let(:mobile_phone)          { patient.mobile_phone }
    let(:primary_phone)         { patient.primary_phone }

    example_request 'Create new patient without email' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Patient.last).to_json
    end
  end

  patch '/patients/:id' do
    before do
      User.destroy_all
      EmergencyContact.destroy_all
      NextKin.destroy_all
    end
    let(:user)    { create(:provider).user }
    let(:patient) { create :patient }
    let(:emergency_contact) { create :emergency_contact }
    let(:next_kin)          { create :next_kin }

    parameter :auth_token,            'Authentication Token',                      required: true
    parameter :email,                 'Email',                 scope: :user
    parameter :id,                    'Patient id',            scope: :patient,    required: true
    parameter :first_name,            'First_name',                            scope: :patient
    parameter :last_name,             'Last name',                             scope: :patient
    parameter :middle_name,           'Middle name',                           scope: :patient
    parameter :birth,                 'Birth date',                            scope: :patient
    parameter :gender,                'Gender',                                scope: :patient
    parameter :mobile_phone,          'Mobile phone',                          scope: :patient
    parameter :primary_phone,         'Primary phone',                         scope: :patient
    parameter :social_number,         'Social number',                         scope: :patient
    parameter :active,                'Boolean, if true - active',             scope: :patient
    parameter :declined_portal_access, 'Boolean, if true - access declined',   scope: :patient
    parameter :preferred_language,    'Preferred language',                    scope: :patient
    parameter :ethnicity,             'Ethnicity',                             scope: :patient
    parameter :american_race,         'Boolean, if true - american race',      scope: :patient
    parameter :asian_race,            'Boolean, if true - asian race',         scope: :patient
    parameter :african_race,          'Boolean, if true - african race',       scope: :patient
    parameter :hawaiian_race,         'Boolean, if true - hawaiian race',      scope: :patient
    parameter :white_race,            'Boolean, if true - white race',         scope: :patient
    parameter :undetermined_race,     'Boolean, if true - undetermined race',  scope: :patient
    parameter :email_reminder,        'Boolean, if true - remind by email',    scope: :patient
    parameter :sms_reminder,          'Boolean, if true - remind by sms',      scope: :patient
    parameter :immunization_registry, 'Immunization registry',                 scope: :patient
    parameter :work_phone,            'Work phone',                            scope: :patient
    parameter :ext,                   'Ext',                                   scope: :patient
    parameter :street_address,        'Street address',                        scope: :patient
    parameter :city,                  'City',                                  scope: :patient
    parameter :state,                 'State',                                 scope: :patient
    parameter :zip,                   'Zip',                                   scope: :patient

    parameter :contact_first_name,     'First name',                           scope: :emergency_contact
    parameter :contact_last_name,      'Last name',                            scope: :emergency_contact
    parameter :contact_middle_name,    'Middle name',                          scope: :emergency_contact
    parameter :contact_relation,       'Relation',                             scope: :emergency_contact
    parameter :contact_mobile_phone,   'Mobile phone',                         scope: :emergency_contact
    parameter :contact_email,          'Email',                                scope: :emergency_contact
    parameter :contact_street_address, 'Street address',                       scope: :emergency_contact
    parameter :contact_city,           'City',                                 scope: :emergency_contact
    parameter :contact_state,          'State',                                scope: :emergency_contact
    parameter :contact_zip,            'Zip',                                  scope: :emergency_contact

    parameter :kin_first_name,     'First name',                               scope: :next_kin
    parameter :kin_last_name,      'Last name',                                scope: :next_kin
    parameter :kin_middle_name,    'Middle name',                              scope: :next_kin
    parameter :kin_relation,       'Relation',                                 scope: :next_kin
    parameter :kin_mobile_phone,   'Mobile phone',                             scope: :next_kin
    parameter :kin_email,          'Email',                                    scope: :next_kin
    parameter :kin_street_address, 'Street address',                           scope: :next_kin
    parameter :kin_city,           'City',                                     scope: :next_kin
    parameter :kin_state,          'State',                                    scope: :next_kin
    parameter :kin_zip,            'Zip',                                      scope: :next_kin

    let(:auth_token)            { user.auth_token }
    let(:email)                 { 'test@email.com' }

    let(:id)                    { patient.id }
    let(:first_name)            { patient.first_name }
    let(:last_name)             { patient.last_name }
    let(:middle_name)           { patient.middle_name }
    let(:birth)                 { patient.birth }
    let(:gender)                { patient.gender }
    let(:mobile_phone)          { Faker::PhoneNumber.phone_number }
    let(:primary_phone)         { Faker::PhoneNumber.phone_number }
    let(:social_number)         { Faker::Internet.password(16) }
    let(:active)                { true }
    let(:declined_portal_access) { true }
    let(:preferred_language)    { Patient.preferred_languages.sample }
    let(:ethnicity)             { Patient.ethnicities.sample }
    let(:american_race)         { false }
    let(:asian_race)            { true }
    let(:african_race)          { false }
    let(:hawaiian_race)         { false }
    let(:white_race)            { false }
    let(:undetermined_race)     { false }
    let(:email_reminder)        { false }
    let(:sms_reminder)          { false }
    let(:immunization_registry) { Patient.immunization_registries.sample }
    let(:work_phone)            { Faker::PhoneNumber.phone_number }
    let(:ext)                   { Faker::Hipster.word.capitalize }
    let(:street_address)        { Faker::Address.street_name }
    let(:city)                  { Faker::Address.city }
    let(:state)                 { State.sample.try(:id) }
    let(:zip)                   { Zipcode.sample.try(:code).try(:to_i) }

    let(:contact_first_name)    { emergency_contact.first_name }
    let(:contact_last_name)     { emergency_contact.last_name }
    let(:contact_middle_name)   { emergency_contact.middle_name }
    let(:contact_relation)      { emergency_contact.relation }
    let(:contact_mobile_phone)  { emergency_contact.mobile_phone }
    let(:contact_email)         { emergency_contact.email }
    let(:contact_street_address) { emergency_contact.street_address }
    let(:contact_city)          { emergency_contact.city }
    let(:contact_state)         { emergency_contact.state }
    let(:contact_zip)           { emergency_contact.zip }

    let(:kin_first_name)        { next_kin.first_name }
    let(:kin_last_name)         { next_kin.last_name }
    let(:kin_middle_name)       { next_kin.middle_name }
    let(:kin_relation)          { next_kin.relation }
    let(:kin_mobile_phone)      { next_kin.mobile_phone }
    let(:kin_email)             { next_kin.email }
    let(:kin_street_address)    { next_kin.street_address }
    let(:kin_city)              { next_kin.city }
    let(:kin_state)             { next_kin.state }
    let(:kin_zip)               { next_kin.zip }

    example_request 'Update patient' do
      expect(status).to        eq 200
    end
  end

  get '/patients/new_appointment' do
    before do
      User.destroy_all
      3.times { create :provider }
    end
    let(:user) { create(:patient).user }

    parameter :auth_token,   'Authentication Token',   scope: :data,   required: true

    let(:auth_token)    { user.auth_token }

    example_request 'List of providers for new appointment' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Provider.all, is_collection: true).to_json
    end
  end

  get '/patients/myhealth' do
    before do
      User.destroy_all
      Provider.destroy_all
      Diagnosis.destroy_all
      Medication.destroy_all
      Portion.destroy_all
      patient = create :patient
      3.times { create :diagnosis, patient_id: patient.id }
      Diagnosis.all.each { |diagnosis| create :medication, diagnosis_id: diagnosis.id }
    end
    let(:patient) { Patient.first }

    parameter :auth_token,   'Authentication Token',   scope: :data,   required: true

    let(:auth_token)    { patient.user.auth_token }

    example_request 'List of medications' do
      expect(status).to        eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/patients/provider_full_info' do
    before do
      User.destroy_all
      provider = create :provider
      3.times { create :location, provider_id: provider.id }
    end
    let(:provider)  { Provider.first }
    let(:patient)   { create :patient }

    parameter :auth_token,   'Authentication Token',   scope: :data,   required: true
    parameter :provider_id,  'Provider id',            scope: :data,   required: true

    let(:auth_token)    { patient.user.auth_token }
    let(:provider_id)   { provider.id }

    example_request 'List of provider locations' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['locations'].count).to eq 3
    end
  end

  post '/patients/create_emergency_contact' do
    before do
      User.destroy_all
      EmergencyContact.destroy_all
    end

    let(:patient) { create :patient }
    let(:emergency_contact) { create :emergency_contact }

    parameter :auth_token,     'Authentication Token',   required: true

    parameter :first_name,     'First name',                           scope: :emergency_contact
    parameter :last_name,      'Last name',                            scope: :emergency_contact
    parameter :middle_name,    'Middle name',                          scope: :emergency_contact
    parameter :relation,       'Relation',                             scope: :emergency_contact
    parameter :mobile_phone,   'Mobile phone',                         scope: :emergency_contact
    parameter :email,          'Email',                                scope: :emergency_contact
    parameter :street_address, 'Street address',                       scope: :emergency_contact
    parameter :city,           'City',                                 scope: :emergency_contact
    parameter :state,          'State',                                scope: :emergency_contact
    parameter :zip,            'Zip',                                  scope: :emergency_contact

    let(:auth_token)     { patient.user.auth_token }

    let(:first_name)     { emergency_contact.first_name }
    let(:last_name)      { emergency_contact.last_name }
    let(:middle_name)    { emergency_contact.middle_name }
    let(:relation)       { emergency_contact.relation }
    let(:mobile_phone)   { emergency_contact.mobile_phone }
    let(:email)          { emergency_contact.email }
    let(:street_address) { emergency_contact.street_address }
    let(:city)           { emergency_contact.city }
    let(:state)          { emergency_contact.state }
    let(:zip)            { emergency_contact.zip }

    example_request 'Create emergency contact' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmergencyContact.last).to_json
    end
  end
end
