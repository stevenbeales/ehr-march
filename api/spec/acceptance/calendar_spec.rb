require 'api_documentation_helper'

RSpec.resource 'Calendar' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/calendars/:id' do
    before do
      User.destroy_all
      Appointment.destroy_all
    end
    let(:user)         { create(:provider).user }
    let!(:appointment) { create :appointment }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Calendar id',          scope: :data,   required: true

    let(:auth_token) { user.auth_token }
    let(:id)         { appointment.calendar.id }

    example_request 'Show calendar' do
      expect(status).to        eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(appointment.calendar).to_json
    end
  end

  get '/calendars/open_reschedule' do
    before do
      User.destroy_all
      Appointment.destroy_all
    end
    let(:user)         { create(:provider).user }
    let!(:appointment) { create :appointment }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :id,         'Calendar id',          scope: :data,   required: true
    parameter :days,       'Amount of days past',  scope: :data,   required: true

    let(:auth_token) { user.auth_token }
    let(:id)         { appointment.calendar.id }
    let(:days)       { '3' }

    example_request 'Open reschedule' do
      expect(status).to        eq 200
      expect(response_body).to eq (JSONAPI::Serializer.serialize(appointment.calendar).merge({ start_time: appointment.calendar.start_time + days.to_i.days, days: days })).to_json
    end
  end

  patch '/calendars/reschedule' do
    before do
      User.destroy_all
      Appointment.destroy_all
      TextMessage.destroy_all
      EmailMessage.destroy_all
    end
    let(:provider)         { create :provider }
    let!(:appointment) { create :appointment }

    parameter :auth_token,          'Authentication Token',                  required: true
    parameter :id,                  'Calendar id',                           required: true
    parameter :days,                'Amount of days past',                   required: true
    parameter :reschedule,          'Boolean, if true - send notification',  required: true
    parameter :old_show_start_time, 'Old appointment datetime',              required: true
    parameter :new_show_start_time, 'New appointment datetime',              required: true

    let(:auth_token)          { provider.user.auth_token }
    let(:id)                  { appointment.calendar.id }
    let(:days)                { 3 }
    let(:reschedule)          { true }
    let(:old_show_start_time) { appointment.appointment_datetime }
    let(:new_show_start_time) { appointment.appointment_datetime.to_time + days.days }

    example_request 'Reschedule' do
      expect(status).to               eq 200
      expect(Appointment.find(appointment.id).calendar.start_time.to_time).to eq appointment.appointment_datetime.to_time + days.days
    end
  end

  get '/calendars/schedule' do
    before do
      User.destroy_all
      Appointment.destroy_all
      provider = create(:provider)
      3.times { create :appointment, provider_id: provider.id }
      Patient.update_all(provider_id: provider.id)
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }

    example_request 'Schedule' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['calendars'].count).to eq 3
      expect(JSON.parse(response_body)['data']['settings']).to eq({ "minTime" => "10:00:00", "maxTime" => "19:00:00", "snapDuration" => "00:30:00" })
    end
  end

  get '/calendars/get_calendars' do
    before do
      User.destroy_all
      Appointment.destroy_all
      provider = create(:provider)
      3.times { create :appointment }
      Patient.update_all(provider_id: provider.id)
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token', scope: :data,   required: true
    parameter :start,      'Start date range',     scope: :data,   required: true
    parameter :end,        'End date range',       scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:start)      { Time.now - 10.hours }
    let(:end)        { Time.now + 10.hours }

    example_request 'Get calendars from range' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['calendars'].count).to eq 3
    end
  end

  get '/calendars/:id/move' do
    before do
      User.destroy_all
      Appointment.destroy_all
    end
    let(:user)         { create(:provider).user }
    let!(:appointment) { create :appointment }

    parameter :auth_token,   'Authentication Token',                 scope: :data,  required: true
    parameter :id,           'Calendar id',                          scope: :data,  required: true
    parameter :all_day,      'Boolean, if true - all day calendar',  scope: :data,  required: true
    parameter :minute_delta, 'Delta between previous date and new date in minutes (can be negative)', scope: :data, required: true

    let(:auth_token)   { user.auth_token }
    let(:id)           { appointment.calendar.id }
    let(:all_day)      { true }
    let(:minute_delta) { 180.minutes }

    example_request 'Move calendar' do
      expect(status).to eq 200
    end
  end

  get '/calendars/:id/resize' do
    before do
      User.destroy_all
      Appointment.destroy_all
    end
    let(:user)         { create(:provider).user }
    let!(:appointment) { create :appointment }

    parameter :auth_token,   'Authentication Token',                 scope: :data,  required: true
    parameter :id,           'Calendar id',                          scope: :data,  required: true
    parameter :minute_delta, 'Delta between previous date and new date in minutes (can be negative)', scope: :data, required: true

    let(:auth_token)   { user.auth_token }
    let(:id)           { appointment.calendar.id }
    let(:minute_delta) { 180.minutes }

    example_request 'Resize calendar' do
      expect(status).to eq 200
    end
  end

  get '/calendars/filter' do
    before do
      User.destroy_all
      Appointment.destroy_all
      Calendar.destroy_all
      Room.destroy_all
      AppointmentType.destroy_all
      AppointmentStatus.destroy_all
      provider = create(:provider)
      appt_room   = create(:room,               provider: provider)
      appt_status = create(:appointment_status, provider: provider)
      appt_type   = create(:appointment_type,   provider: provider)
      3.times { create(:appointment, provider_id: provider.id, location: provider.location1, room: appt_room, appointment_type: appt_type, appointment_status: appt_status) }
      Patient.update_all(provider_id: provider.id)
    end
    let(:provider)     { Provider.first }

    parameter :auth_token,   'Authentication Token',                    scope: :data,  required: true
    parameter :provider_ids, 'An array of ids of providers',            scope: :data,  required: true
    parameter :locations,    'An array of locations',                   scope: :data,  required: true
    parameter :room_ids,     'An array of ids of rooms',                scope: :data,  required: true
    parameter :status_ids,   'An array of ids of appointment statuses', scope: :data,  required: true
    parameter :type_ids,     'An array of ids of appointment types',    scope: :data,  required: true

    let(:auth_token)   { provider.user.auth_token }
    let(:provider_ids) { [provider.id] }
    let(:locations)    { provider.locations }
    let(:room_ids)     { provider.rooms.map(&:id) }
    let(:status_ids)   { provider.appointment_statuses.map(&:id) }
    let(:type_ids)     { provider.appointment_types.map(&:id) }

    example_request 'Filtered calendars' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['calendars'].count).to eq 3
    end
  end
end