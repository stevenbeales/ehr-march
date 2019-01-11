require 'jsonapi-serializers'

class EmergencyContactSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :first_name
  attribute :middle_name
  attribute :last_name
  attribute :relation
  attribute :mobile_phone
  attribute :email
  attribute :street_address
  attribute :city
  attribute :state
  attribute :zip
end
