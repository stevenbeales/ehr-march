require 'api_documentation_helper'

RSpec.resource 'Registration' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/registration/create' do

    before do
      User.destroy_all
    end

    parameter :email,                 'New provider email',                 scope: :user,     required: true
    parameter :password,              'New provider password',              scope: :user,     required: true
    parameter :password_confirmation, 'New provider password confirmation', scope: :user,     required: true
    parameter :first_name,            'New provider first_name',            scope: :provider, required: true

    let(:email)                 { 'doctor@email.com' }
    let(:password)              { 'doctor' }
    let(:password_confirmation) { 'doctor' }
    let(:first_name)            { Faker::Name.first_name }

    example_request 'Registrate new provider' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Provider.first).to_json
    end
  end
end