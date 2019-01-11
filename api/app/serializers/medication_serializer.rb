require 'jsonapi-serializers'

class MedicationSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :diagnosis_id
  attribute :portion_id
  attribute :shorthand
  attribute :signature
  attribute :portion_id
  attribute :start_date
  attribute :stop_date
  attribute :note
end
