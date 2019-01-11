require 'jsonapi-serializers'

class BlockOutSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :time_for
  attribute :block_datetime
  attribute :duration
  attribute :description
  attribute :note
  attribute :recurring
  attribute :recur_every
  attribute :range_day
end
