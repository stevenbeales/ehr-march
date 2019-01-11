require 'jsonapi-serializers'

class CalendarSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :appointment_id
  attribute :title
  attribute :start_time
  attribute :end_time
  attribute :all_day
  attribute :description
end