require 'api_documentation_helper'

RSpec.resource 'Settings' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/settings/practice' do
    before do
      User.destroy_all
      Location.destroy_all
      provider = create :provider
      3.times { create :provider, provider_id: provider.id }
      3.times { create :location, provider_id: provider.id }
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Practices and locations settings' do
      data = JSON.parse(response_body)['data']
      expect(status).to eq 200
      expect(data['practices'].count).to eq 3
      expect(data['locations'].count).to eq 3
    end
  end

  get '/settings/access_permissions' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Practices and locations settings' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(provider.all_permissions, is_collection: true).to_json
    end
  end

  get '/settings/set_admin' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:practice) { create :provider, admin: false }

    parameter :auth_token, 'Authentication Token',                      scope: :data,   required: true
    parameter :id,         'Practice id',                               scope: :data,   required: true
    parameter :admin,      'Boolean, set true if practice is an admin', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { practice.id }
    let(:admin)      { true }

    example_request 'Set practice as an admin' do
      expect(status).to eq 200
      expect(Provider.find(practice.id).admin).to eq admin
    end
  end

  get '/settings/schedule' do
    before do
      User.destroy_all
      provider = create :provider
      3.times { create :provider, provider_id: provider.id, practice_role: :Provider }
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',    scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Practices with role "Provider"' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  patch '/settings/update_schedule' do
    before do
      User.destroy_all
      ScheduleGeneral.destroy_all
      Room.destroy_all
      AppointmentType.destroy_all
      AppointmentStatus.destroy_all
      3.times { create :room }
      3.times { create :appointment_type }
      3.times { create :appointment_status }
    end
    let(:provider) { create :provider }

    parameter :auth_token,             'Authentication Token',              required: true

    parameter :schedule_general_attributes, 'Array of schedule generals',   required: true

    parameter :id,                     'Schedule general id',    scope: :schedule_general_attributes
    parameter :slot_size,              'Slot size',              scope: :schedule_general_attributes
    parameter :past_apps,              'Past apps',              scope: :schedule_general_attributes
    parameter :calendar_from,          'Schedule from time',     scope: :schedule_general_attributes
    parameter :calendar_to,            'Schedule to time',       scope: :schedule_general_attributes
    parameter :outside_practice_hour,  'Outside practice hour',  scope: :schedule_general_attributes
    parameter :multiple_apps,          'Multiple appointments',  scope: :schedule_general_attributes
    parameter :reschedule_for_patient, 'Reschedule for patient', scope: :schedule_general_attributes
    parameter :reschedule_time,        'Reschedule time',        scope: :schedule_general_attributes

    parameter :rooms_attributes,       'Array of rooms',                        required: true

    parameter :room_id,                'Room id',                   scope: :rooms_attributes
    parameter :room,                   'Room',                      scope: :rooms_attributes
    parameter :_destroy,               'Boolean, if true - delete', scope: :rooms_attributes

    parameter :appointment_types_attributes, 'Array of appointment types',      required: true

    parameter :appointment_type_id,    'Appointment type id',       scope: :appointment_types_attributes
    parameter :appt_type,              'Appointment type',          scope: :appointment_types_attributes
    parameter :colour,                 'Appointment type color',    scope: :appointment_types_attributes
    parameter :_destroy,               'Boolean, if true - delete', scope: :appointment_types_attributes

    parameter :appointment_statuses_attributes, 'Array of appointment statuses', required: true

    parameter :appointment_status_id,  'Appointment status id',     scope: :appointment_statuses_attributes
    parameter :name,                   'Appointment status',        scope: :appointment_statuses_attributes
    parameter :colour,                 'Appointment status color',  scope: :appointment_statuses_attributes
    parameter :_destroy,               'Boolean, if true - delete', scope: :appointment_statuses_attributes

    let(:auth_token)             { provider.user.auth_token }

    let(:id)                     { provider.schedule_general.id }
    let(:slot_size)              { provider.schedule_general.slot_size }
    let(:past_apps)              { provider.schedule_general.past_apps }
    let(:calendar_from)          { provider.schedule_general.calendar_from }
    let(:calendar_to)            { provider.schedule_general.calendar_to }
    let(:color_code)             { provider.schedule_general.color_code }
    let(:outside_practice_hour)  { provider.schedule_general.outside_practice_hour }
    let(:multiple_apps)          { provider.schedule_general.multiple_apps }
    let(:reschedule_for_patient) { provider.schedule_general.reschedule_for_patient }
    let(:reschedule_time)        { provider.schedule_general.reschedule_time }

    let(:rooms_attributes)                { Room.all.map{ |room| {room_id: room.id, room: room.room, _destroy: false} } }

    let(:appointment_types_attributes)    { AppointmentType.all.map{ |type| {appointment_type_id: type.id, appt_type: type.appt_type, colour: type.colour, _destroy: false} } }

    let(:appointment_statuses_attributes) { AppointmentStatus.all.map{ |status| {appointment_status_id: status.id, name: status.name, colour: status.colour, _destroy: false} } }

    example_request 'Set colours settings' do
      expect(status).to eq 200
    end
  end

  get '/settings/add_user_added_practice' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:practice) { create :provider }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'User id',              scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { practice.user.id }

    example_request 'Get practice by id' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(practice).to_json
    end
  end

  get '/settings/set_practice_location_color' do
    before do
      User.destroy_all
      Location.destroy_all
    end
    let(:provider) { create :provider }
    let(:location) { create :location }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Location id',          scope: :data,   required: true
    parameter :colour,     'Location color',       scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { location.id }
    let(:colour)     { '#ffffff' }

    example_request 'Set location color' do
      expect(status).to        eq 200
      expect(Location.find(location.id).colour).to eq colour
    end
  end
end