require 'api_documentation_helper'

RSpec.resource 'EmailMessage' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/email_messages' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      user = create(:provider).user
      3.times { create :email_message, to_id: user.id }
    end
    let(:user) { User.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { user.auth_token }

    example_request 'Get first 25 inbox messages' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/email_messages/new' do
    before do
      User.destroy_all
    end
    let(:user)    { create(:provider).user }
    let(:patient) { create :patient }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Patient id',           scope: :data,   required: true

    let(:auth_token) { user.auth_token }
    let(:id) { patient.id }

    example_request 'Get patient by id' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Patient.find(id)).to_json
    end
  end

  post '/email_messages' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:user)    { create(:provider).user }
    let(:patient) { create :patient }
    let(:subject) { create :subject }

    parameter :auth_token, 'Authentication Token',                                          required: true
    parameter :commit,     'If commit = "Send", message will be sent to real email'

    parameter :patient_id, 'Patient id',                           scope: :email_message,   required: true
    parameter :subject_id, 'Subject id',                           scope: :email_message
    parameter :body,       'Message',                              scope: :email_message
    parameter :urgent,     'Boolean, if true - message is urgent', scope: :email_message

    let(:auth_token) { user.auth_token }
    let(:commit)     { 'Save' }

    let(:patient_id) { patient.id }
    let(:subject_id) { subject.id }
    let(:body)       { Faker::Lorem.sentence }
    let(:urgent)     { true }

    example_request 'Create message from current user to patient' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.last).to_json
    end
  end

  post '/email_messages/create_to_practice' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:user)     { create(:provider).user    }
    let(:patient)  { create :patient }
    let(:practice) { create :provider }
    let(:subject)  { create :subject }

    parameter :auth_token,  'Authentication Token',                                          required: true
    parameter :commit,      'If commit = "Send", message will be sent to real email'

    parameter :patient_id,  'Patient id',                           scope: :email_message,   required: true
    parameter :practice_id, 'Practice id',                          scope: :email_message,   required: true
    parameter :subject_id,  'Subject id',                           scope: :email_message
    parameter :body,        'Message',                              scope: :email_message
    parameter :urgent,      'Boolean, if true - message is urgent', scope: :email_message

    let(:auth_token)  { user.auth_token }
    let(:commit)      { 'Save' }

    let(:patient_id)  { patient.id }
    let(:practice_id) { practice.id }
    let(:subject_id)  { subject.id }
    let(:body)        { Faker::Lorem.sentence }
    let(:urgent)      { true }

    example_request 'Create message from current user to patient and practice' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 2
    end
  end

  post '/email_messages/create_from_patient_to_practice' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:patient)  { create :patient }
    let(:practice) { create :provider }
    let(:subject)  { create :subject }

    parameter :auth_token,  'Authentication Token',                                          required: true
    parameter :commit,      'If commit == "Send", message will be sent to real email'

    parameter :to_id,       'Practice id',                          scope: :email_message,   required: true
    parameter :subject_id,  'Subject id',                           scope: :email_message
    parameter :body,        'Message',                              scope: :email_message
    parameter :urgent,      'Boolean, if true - message is urgent', scope: :email_message

    let(:auth_token)  { patient.user.auth_token }
    let(:commit)      { 'Save' }

    let(:to_id)       { practice.id }
    let(:subject_id)  { subject.id }
    let(:body)        { Faker::Lorem.sentence }
    let(:urgent)      { true }

    example_request 'Create message from current patient to practice' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.last).to_json
    end
  end

  post '/email_messages/create_reply' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:user)     { create(:provider).user }
    let(:practice) { create :provider }
    let(:subject)  { create :subject }
    let(:message)  { create :email_message }

    parameter :auth_token,  'Authentication Token',                                          required: true
    parameter :commit,      'If commit == "Send", message will be sent to real email'

    parameter :practice_id, 'Practice id, if present - message will be sent to this practice, but not to the addresser', scope: :email_message
    parameter :message_id,  'Message id, the message you are repling on', scope: :email_message
    parameter :subject_id,  'Subject id',                                 scope: :email_message
    parameter :body,        'Message',                                    scope: :email_message
    parameter :urgent,      'Boolean, if true - message is urgent',       scope: :email_message

    let(:auth_token)  { user.auth_token }
    let(:commit)      { 'Save' }

    let(:practice_id)  { practice.id }
    let(:message_id)   { message.id }
    let(:subject_id)   { subject.id }
    let(:body)         { Faker::Lorem.sentence }
    let(:urgent)       { true }

    example_request 'Create reply message' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.last).to_json
      expect(EmailMessage.last.to.id).to eq practice.user.id
    end
  end

  get '/email_messages/new_tab' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      provider = create :provider
      3.times { create :email_message, to_id: provider.user.id }
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',                        scope: :data,   required: true
    parameter :amount,     'Amount of messages',                          scope: :data,   required: true
    parameter :page,       'Page pagination number',                      scope: :data,   required: true
    parameter :type,       'Type: inbox, sent, draft, archive or urgent', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:amount)     { 2 }
    let(:page)       { 0 }
    let(:type)       { 'inbox' }

    example_request 'Get certain amount of certain type email messages with pagination' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.limit(2), is_collection: true).to_json
    end
  end

  get '/email_messages/new_tab' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      provider = create :provider
      3.times { create :email_message, to_id: provider.user.id }
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',                        scope: :data,   required: true
    parameter :amount,     'Amount of messages',                          scope: :data,   required: true
    parameter :page,       'Page pagination number',                      scope: :data,   required: true
    parameter :type,       'Type: inbox, sent, draft, archive or urgent', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:amount)     { 2 }
    let(:page)       { 0 }
    let(:type)       { 'inbox' }

    example_request 'Get certain amount of certain type email messages with pagination' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.limit(2), is_collection: true).to_json
    end
  end

  get '/email_messages/practice' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }

    parameter :auth_token,   'Authentication Token',       scope: :data,   required: true
    parameter :practice_id,  'Practice id',                scope: :data,   required: true

    let(:auth_token)    { provider.user.auth_token }
    let(:practice_id)   { provider.id }

    example_request 'Get practice by id' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Provider.find(practice_id)).to_json
    end
  end

  get '/email_messages/contacts' do
    before do
      User.destroy_all
      Contact.destroy_all
      provider = create :provider
      3.times{ create :contact, provider_id: provider.id }
    end
    let(:provider) { Provider.first }

    parameter :auth_token,  'Authentication Token',       scope: :data,   required: true
    parameter :page,        'Page number',                scope: :data,   required: true

    let(:auth_token)  { provider.user.auth_token }
    let(:page)        { 0 }

    example_request 'Get 25 contacts with pagination' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/email_messages/find_practices' do
    before do
      User.destroy_all
      provider = create :provider
      create :provider, provider_id: provider.id, first_name: 'Dave',   last_name: 'Stuart'
      create :provider, provider_id: provider.id, first_name: 'Timber', last_name: 'Davison'
      create :provider, provider_id: provider.id, first_name: 'John',   last_name: 'Smith'
    end
    let(:provider) { Provider.first }

    parameter :auth_token,  'Authentication Token',        scope: :data,   required: true
    parameter :part,        'Part of first or last name',  scope: :data

    let(:auth_token)  { provider.user.auth_token }
    let(:part)     { 'Dav' }

    example_request 'Search practice by part of first or last name' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 2
    end
  end

  get '/email_messages/add_contact' do
    before do
      User.destroy_all
      Contact.destroy_all
    end
    let(:provider) { create :provider }

    parameter :auth_token,  'Authentication Token',                    scope: :data,   required: true
    parameter :favorite,    'Boolean, if true - contact is favorite',  scope: :data

    let(:auth_token)  { provider.user.auth_token }
    let(:favorite)    { false }

    example_request 'Create contact' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Contact.first).to_json
    end
  end

  get '/email_messages/favorite_contact' do
    before do
      User.destroy_all
      Contact.destroy_all
    end
    let(:provider) { create :provider }
    let(:contact)  { create :contact }

    parameter :auth_token,  'Authentication Token',                    scope: :data,   required: true
    parameter :contact_id,  'Contact id',                              scope: :data,   required: true
    parameter :favorite,    'Boolean, if true - contact is favorite',  scope: :data

    let(:auth_token)  { provider.user.auth_token }
    let(:contact_id)  { contact.id }
    let(:favorite)    { true }

    example_request 'Switch contact favorite flag' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Contact.first).to_json
      expect(Contact.first.favorite).to eq true
    end
  end

  get '/email_messages/to_archive' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      3.times{ create :email_message }
    end
    let(:provider) { create :provider }

    parameter :auth_token,  'Authentication Token',                                         scope: :data,   required: true
    parameter :message_ids, 'Array of email message ids that should be removed to archive', scope: :data
    parameter :message_id,  'Email message id that should be removed to archive',           scope: :data

    let(:auth_token)  { provider.user.auth_token }
    let(:message_ids) { EmailMessage.all.map{ |message| { id: message.id } } }

    example_request 'Remove messages to archive' do
      expect(status).to eq 200
      expect(EmailMessage.sample.archive).to eq true
    end
  end

  get '/email_messages/delete_message' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      3.times{ create :email_message }
    end
    let(:provider) { create :provider }

    parameter :auth_token,  'Authentication Token',                              scope: :data,   required: true
    parameter :message_ids, 'Array of email message ids that should be deleted', scope: :data
    parameter :message_id,  'Email message id that should be deleted',           scope: :data

    let(:auth_token)  { provider.user.auth_token }
    let(:message_ids) { EmailMessage.all.map{ |message| { id: message.id } } }

    example_request 'Delete messages' do
      expect(status).to eq 200
      expect(EmailMessage.count).to eq 0
    end
  end

  get '/email_messages/mark_as_read' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      3.times{ create :email_message }
    end
    let(:provider) { create :provider }

    parameter :auth_token,  'Authentication Token',                                     scope: :data,   required: true
    parameter :message_ids, 'Array of email message ids that should be marked as read', scope: :data
    parameter :message_id,  'Email message id that should be marked as read',           scope: :data
    parameter :read,        'Boolean, if true - messages will be marked as read',       scope: :data,   required: true

    let(:auth_token)  { provider.user.auth_token }
    let(:message_ids) { EmailMessage.all.map{ |message| { id: message.id } } }
    let(:read)        { true }

    example_request 'Mark messages as read' do
      expect(status).to eq 200
      expect(EmailMessage.sample.read).to eq true
    end
  end

  get '/email_messages/search_message' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      user1 = create :user, email: 'test1@email.com'
      user2 = create :user, email: 'test2@email.com'
      create :provider, user_id: user1.id
      create :provider, user_id: user2.id
      3.times{ create :email_message, to_id: user1.id, from_id: user2.id }
    end
    let(:user) { User.first }

    parameter :auth_token, 'Authentication Token',     scope: :data,   required: true
    parameter :amount,     'Amount of messages',       scope: :data,   required: true
    parameter :page,       'Pagination page number',   scope: :data,   required: true
    parameter :type,       'Type should be one of following: inbox, sent, draft, urgent or archive',  scope: :data,   required: true
    parameter :part,       'Part of user email',       scope: :data,   required: true

    let(:auth_token)  { user.auth_token }
    let(:amount)      { 25 }
    let(:page)        { 1 }
    let(:type)        { 'inbox' }
    let(:part)        { 'te' } # test@email.com

    example_request 'Search messages' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/email_messages/get_subjects' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      3.times{ create :subject }
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',     scope: :data,   required: true

    let(:auth_token)  { user.auth_token }

    example_request 'Get all subjects' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/email_messages/get_subjects' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      3.times{ create :subject }
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token',     scope: :data,   required: true

    let(:auth_token)  { user.auth_token }

    example_request 'Get all subjects' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/email_messages/add_subject' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:user) { create(:provider).user }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :name,       'Subject name',         scope: :data,   required: true

    let(:auth_token)  { user.auth_token }
    let(:name)        { 'Test' }

    example_request 'Create new subject' do
      expect(status).to eq 200
      expect(Subject.first.name).to eq name
    end
  end

  get '/email_messages/update_subject' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:user)    { create(:provider).user }
    let(:subject) { create :subject }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :name,       'Subject name',         scope: :data,   required: true
    parameter :subject_id, 'Subject id',           scope: :data,   required: true

    let(:auth_token)  { user.auth_token }
    let(:name)        { 'Test' }
    let(:subject_id)  { subject.id }

    example_request 'Update subject' do
      expect(status).to eq 200
      expect(Subject.first.name).to eq name
    end
  end

  get '/email_messages/remove_subject' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:user)    { create(:provider).user }
    let(:subject) { create :subject }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :subject_id, 'Subject id',           scope: :data,   required: true

    let(:auth_token)  { user.auth_token }
    let(:subject_id)  { subject.id }

    example_request 'Delete subject' do
      expect(status).to        eq 200
      expect(Subject.count).to eq 0
    end
  end

  get '/email_messages/patients' do
    before do
      User.destroy_all
      provider = create :provider
      create :patient, first_name: 'Dave',   last_name: 'Stuart',  provider_id: provider.id
      create :patient, first_name: 'Timber', last_name: 'Davison', provider_id: provider.id
      create :patient, first_name: 'John',   last_name: 'Smith',   provider_id: provider.id
    end
    let(:provider) { Provider.first }

    parameter :auth_token,  'Authentication Token',        scope: :data,   required: true
    parameter :part,        'Part of first or last name',  scope: :data

    let(:auth_token)  { provider.user.auth_token }
    let(:part)        { 'Dav' }

    example_request 'Search patients by part of first or last name' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 2
    end
  end
end