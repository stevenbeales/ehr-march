require 'jsonapi-serializers'

class DiagnosisCodeSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :code
  attribute :description
end
