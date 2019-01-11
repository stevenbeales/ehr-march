require 'jsonapi-serializers'

class UserSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :email
  attribute :role
  attribute :locked
end