require 'jsonapi-serializers'

class AppointmentSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :room_id
  attribute :appointment_type_id
  attribute :appointment_status_id
  attribute :location
  attribute :reason

  attribute :appointment_datetime_date do
    object.appointment_datetime_date
  end

  attribute :appointment_datetime_time do
    object.appointment_datetime_time
  end

  attribute :duration
  attribute :contact_email
  attribute :contact_phone
  attribute :reminder
  attribute :colour
end
