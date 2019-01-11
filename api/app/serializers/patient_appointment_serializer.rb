require 'jsonapi-serializers'

class PatientAppointmentSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :provider_id
  attribute :patient_id
  attribute :date
  attribute :location
  attribute :appointment_type
  attribute :note
  attribute :phone
  attribute :email
end