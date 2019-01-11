require 'jsonapi-serializers'

class PatientSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :email do
    object.user.email
  end

  attribute :role do
    object.user.role
  end

  attribute :first_name
  attribute :middle_name
  attribute :last_name
  # attribute :birth
  attribute :gender
  attribute :mobile_phone
  attribute :primary_phone
  attribute :code
  attribute :social_number
  attribute :active
  attribute :declined_portal_access
  attribute :preferred_language
  attribute :ethnicity
  attribute :american_race
  attribute :asian_race
  attribute :african_race
  attribute :hawaiian_race
  attribute :white_race
  attribute :undetermined_race
  attribute :email_reminder
  attribute :sms_reminder
  attribute :immunization_registry
  attribute :work_phone
  attribute :ext
  attribute :street_address
  attribute :city
  attribute :state
  attribute :zip
  attribute :profile_image
end
