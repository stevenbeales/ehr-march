require 'jsonapi-serializers'

class ContactSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :provider_id
  attribute :favorite
end