require 'api_documentation_helper'

RSpec.resource 'Locations' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/locations/form' do
    before do
      User.destroy_all
    end
    let(:user)     { create(:provider).user }

    parameter :auth_token,  'Authentication Token', scope: :data,   required: true

    let(:auth_token)  { user.auth_token }

    example_request 'New location' do
      expect(status).to eq 200
    end
  end

  post '/locations' do
    before do
      User.destroy_all
      Location.destroy_all
      7.times { create :timeslot }
    end
    let(:provider)     { create :provider }
    let(:location)     { create :location }

    parameter :auth_token,       'Authentication Token', required: true

    parameter :provider_id,      'Provider id',      scope: :location
    parameter :practice_id,      'Practice id',      scope: :location
    parameter :location_name,    'Location name',    scope: :location
    parameter :location_phone,   'Location phone',   scope: :location
    parameter :location_fax,     'Location fax',     scope: :location
    parameter :location_address, 'Location address', scope: :location
    parameter :city,             'City',             scope: :location
    parameter :state,            'State',            scope: :location
    parameter :zip,              'Zip',              scope: :location
    parameter :location_npi,     'Location NPI',     scope: :location
    parameter :location_tin_en,  'Location TIN EN',  scope: :location

    parameter :timeslots,        'Array of timeslots', scope: :location

    parameter :weekday,          'Weekday',            scope: :timeslots
    parameter :from,             'From time',          scope: :timeslots
    parameter :to,               'To time',            scope: :timeslots
    parameter :specific_hour,    'Specific hour type', scope: :timeslots

    let(:auth_token)       { provider.user.auth_token }
    let(:provider_id)      { provider.id }
    let(:location_name)    { location.location_name }
    let(:location_phone)   { location.location_phone }
    let(:location_fax)     { location.location_fax }
    let(:location_address) { location.location_address }
    let(:city)             { location.city }
    let(:state)            { location.state }
    let(:zip)              { location.zip }
    let(:location_npi)     { location.location_npi }
    let(:location_tin_en)  { location.location_tin_en }

    let(:timeslots)        { Timeslot.limit(7).map{ |slot| {weekday:       slot.weekday,
                                                            from:          slot.from,
                                                            to:            slot.to,
                                                            specific_hour: slot.specific_hour} } }

    example_request 'Create location' do
      expect(status).to eq 200
    end
  end

  get '/locations/form' do
    before do
      User.destroy_all
      Location.destroy_all
    end
    let(:user)     { create(:provider).user }
    let(:location) { create :location }

    parameter :auth_token,  'Authentication Token', scope: :data,   required: true
    parameter :id,          'Location id',          scope: :data,   required: true

    let(:auth_token)  { user.auth_token }
    let(:id)          { location.id }

    example_request 'Get location for edit' do
      expect(status).to eq 200
      expect(response_body).to eq(JSONAPI::Serializer.serialize(Location.find(id)).to_json)
    end
  end

  patch '/locations/:id' do
    before do
      User.destroy_all
      Location.destroy_all
      location = create :location
      7.times { create :timeslot, location_id: location.id }
    end
    let(:provider)     { create :provider }

    parameter :auth_token,       'Authentication Token', required: true

    parameter :timeslots,        'Array of timeslots', scope: :location

    parameter :weekday,          'Weekday',            scope: :timeslots
    parameter :from,             'From time',          scope: :timeslots
    parameter :to,               'To time',            scope: :timeslots
    parameter :specific_hour,    'Specific hour type', scope: :timeslots

    let(:auth_token)  { provider.user.auth_token }
    let(:timeslots)   { Timeslot.limit(7).map{ |slot| {id:            slot.id,
                                                       location_id:   slot.location_id,
                                                       weekday:       slot.weekday,
                                                       from:          slot.from,
                                                       to:            slot.to,
                                                       specific_hour: slot.specific_hour} } }

    example_request 'Update timeslots' do
      expect(status).to eq 200
    end
  end

  get '/locations/primary_location' do
    before do
      User.destroy_all
      Location.destroy_all
    end
    let(:location) { create :location }
    let(:provider) { create :provider }

    parameter :auth_token,  'Authentication Token',                          scope: :data,   required: true
    parameter :id,          'Location id',                                   scope: :data,   required: true

    let(:auth_token)  { provider.user.auth_token }
    let(:id)          { location.id }

    example_request 'Set location as primary' do
      expect(status).to eq 200
    end
  end
end