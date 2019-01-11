require 'api_documentation_helper'

RSpec.resource 'Referral' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/referrals/new' do
    before do
      User.destroy_all
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',       scope: :data

    let(:auth_token) { user.auth_token }

    example_request 'New referral' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['type']).to eq 'referrals'
    end
  end

  post '/referrals' do
    before do
      User.destroy_all
      Referral.destroy_all
    end
    let(:user)      { create(:provider).user }

    parameter :auth_token,     'Authentication Token',                     required: true
    parameter :normal,         'Normal',              scope: :referral
    parameter :middle_name,    'Middle name',         scope: :referral
    parameter :last_name,      'Last name',           scope: :referral
    parameter :individual_npi, 'Individual npi',      scope: :referral
    parameter :speciality,     'Speciality',          scope: :referral
    parameter :phone,          'Phone',               scope: :referral
    parameter :fax,            'Fax',                 scope: :referral
    parameter :email,          'Email',               scope: :referral

    let(:auth_token)      { user.auth_token }
    let(:normal)          { Faker::Name.first_name }
    let(:middle_name)     { Faker::Name.first_name }
    let(:last_name)       { Faker::Name.last_name }
    let(:individual_npi)  { Faker::Company.ein }
    let(:speciality)      { Referral.specialities.sample }
    let(:phone)           { Faker::PhoneNumber.phone_number }
    let(:fax)             { Faker::PhoneNumber.phone_number }
    let(:email)           { Faker::Internet.email }

    example_request 'Create referral' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Referral.last).to_json
    end
  end
end