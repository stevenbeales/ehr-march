require 'jsonapi-serializers'

class EncounterSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :provider_id
  attribute :patient_id
  attribute :notes
  attribute :med_completed
  attribute :patient_education
  attribute :clinical_summary
  attribute :to_provider_id
  attribute :from_provider_id
end
