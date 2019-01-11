require 'api_documentation_helper'

RSpec.resource 'Practices' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/practices' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:practice) { create :provider }
    let(:user)     { create(:provider).user }

    parameter :auth_token,            'Authentication Token',                               required: true
    parameter :user,                  'User parameters',                                    required: true
    parameter :practice,              'Practice parameters',                                required: true
    parameter :email,                 'Practice email',                   scope: :user,     required: true
    parameter :password,              'Practice password',                scope: :user,     required: true
    parameter :password_confirmation, 'Practice password confirmation',   scope: :user,     required: true
    
    parameter :practice_role,            'Practice role',            scope: :practice
    parameter :provider_id,              'Provider id',              scope: :practice
    parameter :title,                    'Mr/Ms/Dr',                 scope: :practice
    parameter :first_name,               'First name',               scope: :practice
    parameter :middle_name,              'Middle name',              scope: :practice
    parameter :last_name,                'Last name',                scope: :practice
    parameter :degree,                   'Degree',                   scope: :practice
    parameter :speciality,               'Speciality',               scope: :practice
    parameter :secondary_speciality,     'Secondary speciality',     scope: :practice
    parameter :dental_licence,           'Dental licence',           scope: :practice
    parameter :street_address,           'Street address',           scope: :practice
    parameter :suit_apt_number,          'Suit apt number',          scope: :practice
    parameter :city,                     'City',                     scope: :practice
    parameter :state,                    'State',                    scope: :practice
    parameter :zip,                      'Zip',                      scope: :practice
    parameter :practice_street_address,  'Practice street address',  scope: :practice
    parameter :practice_suit_apt_number, 'Practice suit apt number', scope: :practice
    parameter :practice_city,            'Practice city',            scope: :practice
    parameter :practice_state,           'Practice state',           scope: :practice
    parameter :practice_zip,             'Practice zip',             scope: :practice
    parameter :expiration_date,          'Expiration date',          scope: :practice
    parameter :ein_tin,                  'EIN TIN',                  scope: :practice
    parameter :npi,                      'NPI',                      scope: :practice
    parameter :dea,                      'DEA',                      scope: :practice
    parameter :upin,                     'UPIN',                     scope: :practice
    parameter :nadean,                   'NADEAN',                   scope: :practice
    parameter :accepting_patient,        'Accepting patient',        scope: :practice
    parameter :enable_online_booking,    'Enable online booking',    scope: :practice
    parameter :biography,                'Biography',                scope: :practice
    parameter :primary_phone,            'Primay phone',             scope: :practice
    parameter :mobile_phone,             'mobile phone',             scope: :practice
    parameter :alt_email,                'Alternative email',        scope: :practice
    parameter :username,                 'Username',                 scope: :practice
    parameter :profile_image,            'Profile image',            scope: :practice

    let(:auth_token) { provider.user.auth_token }

    let(:email)                 { 'test@email.com' }
    let(:password)              { user.password }
    let(:password_confirmation) { user.password }

    let(:practice_role)            { practice.practice_role }
    let(:provider_id)              { practice.provider_id }
    let(:title)                    { practice.title }
    let(:first_name)               { practice.first_name }
    let(:middle_name)              { practice.middle_name }
    let(:last_name)                { practice.last_name }
    let(:degree)                   { practice.degree }
    let(:speciality)               { practice.speciality }
    let(:secondary_speciality)     { practice.secondary_speciality }
    let(:dental_licence)           { practice.dental_licence }
    let(:street_address)           { practice.street_address }
    let(:suit_apt_number)          { practice.suit_apt_number }
    let(:city)                     { practice.city }
    let(:state)                    { practice.state }
    let(:zip)                      { practice.zip }
    let(:practice_street_address)  { practice.practice_street_address }
    let(:practice_suit_apt_number) { practice.practice_suit_apt_number }
    let(:practice_city)            { practice.practice_city }
    let(:practice_state)           { practice.practice_state }
    let(:practice_zip)             { practice.practice_zip }
    let(:expiration_date)          { practice.expiration_date }
    let(:ein_tin)                  { practice.ein_tin }
    let(:npi)                      { practice.npi }
    let(:dea)                      { practice.dea }
    let(:upin)                     { practice.upin }
    let(:nadean)                   { practice.nadean }
    let(:accepting_patient)        { practice.accepting_patient }
    let(:enable_online_booking)    { practice.enable_online_booking }
    let(:biography)                { practice.biography }
    let(:primary_phone)            { practice.primary_phone }
    let(:mobile_phone)             { practice.mobile_phone }
    let(:alt_email)                { practice.alt_email }
    let(:username)                 { practice.username }

    example_request 'Create practice' do
      expect(status).to eq 200
    end
  end

  get '/practices/:id/edit' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:practice) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Practice id',          scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { practice.id }

    example_request 'Get practice for edit' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Provider.find(id)).to_json
    end
  end

  patch '/practices/:id' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:practice) { create :provider }

    parameter :auth_token,            'Authentication Token',                               required: true
    parameter :user,                  'User parameters'
    parameter :user_id,               'User id',                          scope: :user,     required: true
    parameter :practice,              'Practice parameters'
    parameter :practice_id,           'Practice id',                      scope: :practice, required: true
    parameter :email,                 'Practice email',                   scope: :user
    parameter :password,              'Practice password',                scope: :user
    parameter :password_confirmation, 'Practice password confirmation',   scope: :user

    parameter :practice_role,            'Practice role',            scope: :practice
    parameter :provider_id,              'Provider id',              scope: :practice
    parameter :title,                    'Mr/Ms/Dr',                 scope: :practice
    parameter :first_name,               'First name',               scope: :practice
    parameter :middle_name,              'Middle name',              scope: :practice
    parameter :last_name,                'Last name',                scope: :practice
    parameter :degree,                   'Degree',                   scope: :practice
    parameter :speciality,               'Speciality',               scope: :practice
    parameter :secondary_speciality,     'Secondary speciality',     scope: :practice
    parameter :dental_licence,           'Dental licence',           scope: :practice
    parameter :street_address,           'Street address',           scope: :practice
    parameter :suit_apt_number,          'Suit apt number',          scope: :practice
    parameter :city,                     'City',                     scope: :practice
    parameter :state,                    'State',                    scope: :practice
    parameter :zip,                      'Zip',                      scope: :practice
    parameter :practice_street_address,  'Practice street address',  scope: :practice
    parameter :practice_suit_apt_number, 'Practice suit apt number', scope: :practice
    parameter :practice_city,            'Practice city',            scope: :practice
    parameter :practice_state,           'Practice state',           scope: :practice
    parameter :practice_zip,             'Practice zip',             scope: :practice
    parameter :expiration_date,          'Expiration date',          scope: :practice
    parameter :ein_tin,                  'EIN TIN',                  scope: :practice
    parameter :npi,                      'NPI',                      scope: :practice
    parameter :dea,                      'DEA',                      scope: :practice
    parameter :upin,                     'UPIN',                     scope: :practice
    parameter :nadean,                   'NADEAN',                   scope: :practice
    parameter :accepting_patient,        'Accepting patient',        scope: :practice
    parameter :enable_online_booking,    'Enable online booking',    scope: :practice
    parameter :biography,                'Biography',                scope: :practice
    parameter :primary_phone,            'Primay phone',             scope: :practice
    parameter :mobile_phone,             'mobile phone',             scope: :practice
    parameter :alt_email,                'Alternative email',        scope: :practice
    parameter :username,                 'Username',                 scope: :practice
    parameter :profile_image,            'Profile image',            scope: :practice

    let(:auth_token)  { provider.user.auth_token }
    let(:user_id)     { practice.user.id }
    let(:practice_id) { practice.id }

    let(:email)                 { practice.user.email }
    let(:password)              { practice.user.password }
    let(:password_confirmation) { practice.user.password }

    let(:practice_role)            { practice.practice_role }
    let(:provider_id)              { practice.provider_id }
    let(:title)                    { practice.title }
    let(:first_name)               { practice.first_name }
    let(:middle_name)              { practice.middle_name }
    let(:last_name)                { practice.last_name }
    let(:degree)                   { practice.degree }
    let(:speciality)               { practice.speciality }
    let(:secondary_speciality)     { practice.secondary_speciality }
    let(:dental_licence)           { practice.dental_licence }
    let(:street_address)           { practice.street_address }
    let(:suit_apt_number)          { practice.suit_apt_number }
    let(:city)                     { practice.city }
    let(:state)                    { practice.state }
    let(:zip)                      { practice.zip }
    let(:practice_street_address)  { practice.practice_street_address }
    let(:practice_suit_apt_number) { practice.practice_suit_apt_number }
    let(:practice_city)            { practice.practice_city }
    let(:practice_state)           { practice.practice_state }
    let(:practice_zip)             { practice.practice_zip }
    let(:expiration_date)          { practice.expiration_date }
    let(:ein_tin)                  { practice.ein_tin }
    let(:npi)                      { practice.npi }
    let(:dea)                      { practice.dea }
    let(:upin)                     { practice.upin }
    let(:nadean)                   { practice.nadean }
    let(:accepting_patient)        { practice.accepting_patient }
    let(:enable_online_booking)    { practice.enable_online_booking }
    let(:biography)                { practice.biography }
    let(:primary_phone)            { practice.primary_phone }
    let(:mobile_phone)             { practice.mobile_phone }
    let(:alt_email)                { practice.alt_email }
    let(:username)                 { practice.username }

    example_request 'Update practice' do
      expect(status).to eq 200
    end
  end
end
