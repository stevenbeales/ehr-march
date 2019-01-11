require 'jsonapi-serializers'

class PayerSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :name
  attribute :plan
  attribute :plan_type
end
