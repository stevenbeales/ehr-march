require 'jsonapi-serializers'

class AllergySerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :allergen_type
  attribute :severity_level
  attribute :onset_at
  attribute :start_date
  attribute :active
  attribute :note
end
