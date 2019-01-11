require 'jsonapi-serializers'

class PastMedicalHistorySerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :major_events
  attribute :ongoing_problems
  attribute :preventitive_care
  attribute :nutrition_history
  attribute :developmental_history
end