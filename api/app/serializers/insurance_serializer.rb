require 'jsonapi-serializers'

class InsuranceSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :provider_id
  attribute :payer_id
  attribute :worker_compensation
  attribute :insurance_number
  attribute :relation
  attribute :effective_from
  attribute :effective_to
  attribute :copay_type
  attribute :copay_amount
  attribute :claim
  attribute :note
  attribute :active
end
