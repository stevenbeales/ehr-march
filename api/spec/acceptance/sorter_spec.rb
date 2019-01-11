require 'api_documentation_helper'

RSpec.resource 'Sorter' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/sorter/appointments' do
    before do
      User.destroy_all
      Appointment.destroy_all
      provider = create :provider

      create :appointment, provider_id: provider.id
      create :appointment, provider_id: provider.id
      create :appointment, provider_id: provider.id
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',           scope: :data,   required: true
    parameter :page,       'Pagination page number',         scope: :data,   required: true
    parameter :field,      'Field order by, can be: "appointment_datetime_time", "patient", "appointment_type" other variants return all appointments', scope: :data
    parameter :type,       'Type of order: "asc" or "desc"', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:page)       { 0 }
    let(:field)      { 'patient' }
    let(:type)       { 'desc' }

    example_request 'Sort appointments and paginate' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/sorter/messages' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      provider = create :provider
      3.times{ create :email_message, to_id: provider.user.id }
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',           scope: :data,   required: true
    parameter :field,      'Field order by, can be: "from", "created_at" other variants return all inbox', scope: :data
    parameter :type,       'Type of order: "asc" or "desc"', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:field)      { 'created_at' }
    let(:type)       { 'asc' }

    example_request 'Sort inbox messages' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/sorter/todos' do
    before do
      User.destroy_all
      Appointment.destroy_all
      provider = create :provider

      create :appointment, provider_id: provider.id
      create :appointment, provider_id: provider.id
      create :appointment, provider_id: provider.id
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',           scope: :data,   required: true
    parameter :field,      'Field order by, can be: "patient", "created_at", "appointment_type" other variants return all to dos', scope: :data
    parameter :type,       'Type of order: "asc" or "desc"', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:field)      { 'appointment_type' }
    let(:type)       { 'desc' }

    example_request 'Sort inbox messages' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end
end