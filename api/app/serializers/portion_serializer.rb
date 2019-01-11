require 'jsonapi-serializers'

class PortionSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :drug
  attribute :dose
  attribute :instruction
end
