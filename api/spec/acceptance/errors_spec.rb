require 'api_documentation_helper'

RSpec.resource 'Errors' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/errors/show' do
    before do
      User.destroy_all
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',    scope: :data,   required: true
    parameter :code,       'Error code(404, 500...)', scope: :data

    let(:auth_token) { user.auth_token }
    let(:code)       { 404 }

    example_request 'Show' do
      expect(status).to eq 404
      expect(response_body).to eq({code: '404'}.to_json)
    end
  end
end