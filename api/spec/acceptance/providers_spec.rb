require 'api_documentation_helper'

RSpec.resource 'Providers' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/providers'do
    before do
      User.destroy_all
      Appointment.destroy_all
      provider = create :provider

      3.times { create :email_message, to_id: provider.user.id }

      create :appointment, provider_id: provider.id
      create :appointment, provider_id: provider.id
      create :appointment, provider_id: provider.id
    end

    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :page,       'Page pagination',      scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:page)       { 0 }

    example_request 'Index' do
      data = JSON.parse(response_body)['data']
      expect(status).to                     eq 200
      expect(data['appointments'].count).to eq 3
      expect(data['messages'].count).to     eq 3
      expect(data['to_dos'].count).to       eq 3
    end
  end

  get '/providers/add_patient'do
    before do
      User.destroy_all
    end

    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Add patient' do
      data = JSON.parse(response_body)['data']
      expect(status).to eq 200
      expect(data['code'].present?).to eq true
      expect(data['user'].present?).to eq true
    end
  end

  get '/providers/download_pdf'do
    before do
      User.destroy_all
    end

    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :name,       'Patient full name',    scope: :data,   required: true
    parameter :birth,      'Patient birth date',   scope: :data,   required: true
    parameter :code,       'Activation code',      scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:name)       { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    let(:birth)      { Time.now }
    let(:code)       { Activation.code }

    example_request 'Download pdf' do
      expect(status).to eq 200
    end
  end

  get '/providers/send_invite_email'do
    before do
      User.destroy_all
    end

    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :first_name, 'Patient first name',   scope: :data,   required: true
    parameter :last_name,  'Patient last name',    scope: :data,   required: true
    parameter :birth,      'Patient birth date',   scope: :data,   required: true
    parameter :code,       'Activation code',      scope: :data,   required: true
    parameter :email,      'Patient email',        scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:first_name) { Faker::Name.first_name }
    let(:last_name)  { Faker::Name.last_name }
    let(:birth)      { Time.now }
    let(:code)       { Activation.code }
    let(:email)      { Faker::Internet.email }

    example_request 'Send invitation email' do
      expect(status).to eq 200
    end
  end

  post '/providers/save_message'do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
    end
    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token',                                           required: true
    parameter :to_id,      'User id',                              scope: :email_message,    required: true
    parameter :subject_id, 'Subject id',                           scope: :email_message
    parameter :body,       'Message',                              scope: :email_message
    parameter :urgent,     'Boolean, if true - message is urgent', scope: :email_message
    parameter :commit,     'If "Send" message will be sent to real email'

    let(:auth_token) { provider.user.auth_token }
    let(:to_id)      { create(:user).id }
    let(:subject_id) { create(:subject).id }
    let(:body)       { Faker::Lorem.sentence }
    let(:urgent)     { false }

    example_request 'Save email message' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.last).to_json
    end
  end

  get '/providers/prev_message' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      provider = create :provider
      3.times{ create :email_message, to_id: provider.user.id }
    end

    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :message_id, 'message id',           scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:message_id) { EmailMessage.first.id }

    example_request 'Get previous message' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.last).to_json
    end
  end

  get '/providers/next_message' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      provider = create :provider
      3.times{ create :email_message, to_id: provider.user.id }
    end

    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :message_id, 'message id',           scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:message_id) { EmailMessage.last.id }

    example_request 'Get next message' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.first).to_json
    end
  end

  get '/providers/first_message' do
    before do
      User.destroy_all
      EmailMessage.destroy_all
      Subject.destroy_all
      provider = create :provider
      3.times{ create :email_message, to_id: provider.user.id }
    end

    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Get first inbox message' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(EmailMessage.first).to_json
    end
  end

  patch '/providers/:id' do
    before do
      User.destroy_all
      BlockOut.destroy_all
      Appointment.destroy_all
      provider = create :provider
      patient  = create :patient, provider_id: provider.id
      create :block_out, patient_id: patient.id
      appointment = create :appointment, patient_id: patient.id
      create :referral, appointment_id: appointment.id
    end

    let(:provider_ex) { Provider.first }

    parameter :auth_token, 'Authentication Token',   required: true
    parameter :id,         'Provider id',            required: true
    
    parameter :provider,    'Provider params',       required: true
    parameter :user,        'User params',           required: true
    parameter :patient,     'Patient params',        required: true
    parameter :block_out,   'Block out params',      required: true
    parameter :appointment, 'Appointment params',    required: true
    parameter :referral,    'Referral params',       required: true

    let(:auth_token) { provider_ex.user.auth_token }
    let(:id)         { provider_ex.id }
    
    let(:provider)   {{
      title:                    provider_ex.title,
      first_name:               provider_ex.first_name,
      middle_name:              provider_ex.middle_name,
      last_name:                provider_ex.last_name,
      degree:                   provider_ex.degree,
      speciality:               provider_ex.speciality,
      secondary_speciality:     provider_ex.secondary_speciality,
      dental_licence:           provider_ex.dental_licence,
      street_address:           provider_ex.street_address,
      suit_apt_number:          provider_ex.suit_apt_number,
      city:                     provider_ex.city,
      state:                    provider_ex.state,
      zip:                      provider_ex.zip,
      practice_street_address:  provider_ex.practice_street_address,
      practice_suit_apt_number: provider_ex.practice_suit_apt_number,
      practice_city:            provider_ex.practice_city,
      practice_state:           provider_ex.practice_state,
      practice_zip:             provider_ex.practice_zip,
      expiration_date:          provider_ex.expiration_date,
      ein_tin:                  provider_ex.ein_tin,
      npi:                      provider_ex.npi,
      dea:                      provider_ex.dea,
      upin:                     provider_ex.upin,
      nadean:                   provider_ex.nadean,
      accepting_patient:        provider_ex.accepting_patient,
      enable_online_booking:    provider_ex.enable_online_booking,
      biography:                provider_ex.biography,
      primary_phone:            provider_ex.primary_phone,
      mobile_phone:             provider_ex.mobile_phone,
      alt_email:                provider_ex.alt_email,
      username:                 provider_ex.username
    }}
    
    let(:user) {{
      id:                       provider_ex.user.id,
      email:                    provider_ex.user.email,
      password:                 provider_ex.user.password,
      password_confirmation:    provider_ex.user.password_confirmation
    }}
    
    let(:patient) {{
      id:                       provider_ex.patients.first.id,
      user_id:                  provider_ex.patients.first.user_id,
      provider_id:              provider_ex.patients.first.provider_id,
      first_name:               provider_ex.patients.first.first_name,
      last_name:                provider_ex.patients.first.last_name,
      middle_name:              provider_ex.patients.first.middle_name,
      birth:                    provider_ex.patients.first.birth,
      gender:                   provider_ex.patients.first.gender,
      mobile_phone:             provider_ex.patients.first.mobile_phone,
      primary_phone:            provider_ex.patients.first.primary_phone,
      code:                     provider_ex.patients.first.code
    }}
    
    let(:block_out) {{
        id:                     provider_ex.patients.first.block_outs.first.id,
        time_for:               provider_ex.patients.first.block_outs.first.time_for,
        block_datetime:         provider_ex.patients.first.block_outs.first.block_datetime,
        duration:               provider_ex.patients.first.block_outs.first.duration,
        description:            provider_ex.patients.first.block_outs.first.description,
        note:                   provider_ex.patients.first.block_outs.first.note,
        recurring:              provider_ex.patients.first.block_outs.first.recurring,
        recur_every:            provider_ex.patients.first.block_outs.first.recur_every,
        range_day:              provider_ex.patients.first.block_outs.first.range_day
    }}
    
    let(:appointment) {{
        id:                     provider_ex.patients.first.appointments.first.id,
        patient_id:             provider_ex.patients.first.appointments.first.patient_id,
        location:               provider_ex.patients.first.appointments.first.location,
        room:                   provider_ex.patients.first.appointments.first.room,
        appointment_type:       provider_ex.patients.first.appointments.first.appointment_type,
        reason:                 provider_ex.patients.first.appointments.first.reason,
        appointment_datetime:   provider_ex.patients.first.appointments.first.appointment_datetime,
        duration:               provider_ex.patients.first.appointments.first.duration,
        contact_email:          provider_ex.patients.first.appointments.first.contact_email,
        contact_phone:          provider_ex.patients.first.appointments.first.contact_phone,
        reminder:               provider_ex.patients.first.appointments.first.reminder,
        colour:                 provider_ex.patients.first.appointments.first.colour
    }}
    
    let(:referral) {{
      id:                       provider_ex.patients.first.appointments.first.referrals.first.id,
      normal:                   provider_ex.patients.first.appointments.first.referrals.first.normal,
      middle_name:              provider_ex.patients.first.appointments.first.referrals.first.middle_name,
      last_name:                provider_ex.patients.first.appointments.first.referrals.first.last_name,
      individual_npi:           provider_ex.patients.first.appointments.first.referrals.first.individual_npi,
      speciality:               provider_ex.patients.first.appointments.first.referrals.first.speciality,
      phone:                    provider_ex.patients.first.appointments.first.referrals.first.phone,
      fax:                      provider_ex.patients.first.appointments.first.referrals.first.fax,
      email:                    provider_ex.patients.first.appointments.first.referrals.first.email
    }}

    example_request 'Update provider' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Provider.first).to_json
    end
  end

  get '/providers/lock' do
    before do
      User.destroy_all
    end

    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Lock provider user' do
      expect(status).to eq 200
      expect(Provider.first.user.locked).to eq true
    end
  end

  post '/providers/unlock' do
    before do
      User.destroy_all
    end

    let(:password) { 'tester' }
    let(:user)     { create :user, password: password, password_confirmation: password }
    let(:provider) { create :provider, user_id: user.id }

    parameter :auth_token, 'Authentication Token',   required: true
    parameter :password,   'Current user password',  required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Unlock provider user' do
      expect(status).to eq 200
      expect(User.first.locked).to eq false
    end
  end
end
