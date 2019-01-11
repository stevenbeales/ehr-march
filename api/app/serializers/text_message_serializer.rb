require 'jsonapi-serializers'

class TextMessageSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :provider_id
  attribute :patient_id
  attribute :to
  attribute :from
  attribute :body
end