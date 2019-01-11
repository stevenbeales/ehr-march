require 'jsonapi-serializers'

class LocationSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :provider_id
  attribute :location_name
  attribute :location_phone
  attribute :location_fax
  attribute :location_address
  attribute :city
  attribute :state
  attribute :zip
  attribute :location_npi
  attribute :location_tin_en
  attribute :colour
end
