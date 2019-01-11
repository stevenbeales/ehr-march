require 'jsonapi-serializers'

class GuarantorSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id
  attribute :first_name
  attribute :middle_name
  attribute :last_name
  attribute :birth
  attribute :gender
  attribute :social_number
  attribute :relation
  attribute :phone
  attribute :email
  attribute :street_address
  attribute :city
  attribute :state
  attribute :zip
end
