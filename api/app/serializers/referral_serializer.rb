require 'jsonapi-serializers'

class ReferralSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :appointment_id
  attribute :normal
  attribute :middle_name
  attribute :last_name
  attribute :individual_npi
  attribute :speciality
  attribute :phone
  attribute :fax
  attribute :email
end