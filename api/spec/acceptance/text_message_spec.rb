require 'api_documentation_helper'

RSpec.resource 'Text message' do
  header 'Content-Type', 'application/vnd.api+json'

  post '/text_messages' do
    before do
      User.destroy_all
      TextMessage.destroy_all
    end
    let(:user)     { create(:provider).user }

    parameter :auth_token,     'Authentication Token',   required: true
    parameter :To,             'To(email)',              required: true
    parameter :From,           'From(email)',            required: true
    parameter :Body,           'Message',                required: true

    let(:auth_token) { user.auth_token }
    let(:To)         { Faker::Internet.email }
    let(:From)       { Faker::Internet.email }
    let(:Body)       { Faker::Lorem.paragraph }

    example_request 'Create text message' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(TextMessage.last).to_json
    end
  end
end