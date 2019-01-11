require 'api_documentation_helper'

RSpec.resource 'Dashboard' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/dashboard/index' do
    before do
      User.destroy_all
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { user.auth_token }

    example_request 'Index' do
      expect(status).to eq 200
    end
  end
end