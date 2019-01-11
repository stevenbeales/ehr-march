require 'jsonapi-serializers'

class EmailMessageSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :subject_id
  attribute :to_id
  attribute :from_id

  attribute :body
  attribute :draft
  attribute :archive
  attribute :urgent
  attribute :read
end
