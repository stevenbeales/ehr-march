require 'api_documentation_helper'

RSpec.resource 'Session' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/sessions/create' do
    response_field :auth_token, 'Authentication Token'

    before do
      User.destroy_all
    end
    let(:user) { create :user, email: 'doctor@email.com', password: 'doctor' }
    let(:provider) { create :provider, user_id: user.id }

    parameter :email,    'User email',      required: true
    parameter :password, 'User password',   required: true

    let(:email)    { user.email }
    let(:password) { 'doctor' }

    example_request 'Authorization' do
      current_user = User.find(user.id)
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(current_user).merge({auth_token: current_user.auth_token}).to_json
    end
  end

  delete '/sessions/destroy' do
    before do
      User.destroy_all
    end

    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',   required: true

    let(:auth_token) { user.auth_token }

    example_request 'Log out' do
      expect(status).to eq 204
    end
  end
end