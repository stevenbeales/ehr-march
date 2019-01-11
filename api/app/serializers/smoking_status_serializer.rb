require 'jsonapi-serializers'

class SmokingStatusSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :status
  attribute :effective_from
end