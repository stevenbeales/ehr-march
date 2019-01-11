require 'jsonapi-serializers'

class DiagnosisSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :diagnosis_code_id
  attribute :start_date
  attribute :stop_date
  attribute :acute
  attribute :terminal
  attribute :note
end
