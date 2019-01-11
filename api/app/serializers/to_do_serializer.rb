require 'jsonapi-serializers'

class ToDoSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :appointment_id
  attribute :done
end