require 'api_documentation_helper'

RSpec.resource 'Zipcodes' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/zipcodes/city_set' do
    before do
      User.destroy_all
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',         scope: :data,   required: true
    parameter :city,       'The beginning of a city name', scope: :data,   required: true

    let(:auth_token) { user.auth_token }
    let(:city)       { 'Wash' }

    example_request 'List of cities' do
      expect(status).to eq 200
      expect(JSON.parse(response_body).map{ |z| z['city'] }).to eq ["Washington", "Washington", "Washburn", "Washington", "Washington"]
    end
  end

  get '/zipcodes/zip_set' do
    before do
      User.destroy_all
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',        scope: :data,   required: true
    parameter :zip,        'The beginning of a zip code', scope: :data,   required: true

    let(:auth_token) { user.auth_token }
    let(:zip)        { '132' }

    example_request 'List of zipcodes' do
      expect(status).to eq 200
      expect(JSON.parse(response_body).map{ |z| z['code'] }).to eq ["13201", "13202", "13203", "13204", "13205"]
    end
  end
end