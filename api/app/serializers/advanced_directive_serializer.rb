require 'jsonapi-serializers'

class AdvancedDirectiveSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :record_date
  attribute :notes
end
