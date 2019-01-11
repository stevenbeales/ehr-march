require 'jsonapi-serializers'

class SubjectSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :name
end