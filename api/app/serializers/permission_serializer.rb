require 'jsonapi-serializers'

class PermissionSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :presentation
  attribute :policy_name
end
