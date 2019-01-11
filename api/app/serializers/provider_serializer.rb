require 'jsonapi-serializers'

class ProviderSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :email do
    object.user.email
  end

  attribute :role do
    object.user.role
  end

  attribute :user_id
  attribute :title
  attribute :first_name
  attribute :middle_name
  attribute :last_name
  attribute :degree
  attribute :speciality
  attribute :street_address
  attribute :suit_apt_number
  attribute :city
  attribute :state
  attribute :zip
  attribute :practice_street_address
  attribute :practice_suit_apt_number
  attribute :practice_city
  attribute :practice_state
  attribute :practice_zip
  attribute :primary_phone
  attribute :mobile_phone
  attribute :alt_email
  attribute :username
  attribute :secondary_speciality
  attribute :dental_licence
  attribute :expiration_date
  attribute :ein_tin
  attribute :npi
  attribute :dea
  attribute :upin
  attribute :nadean
  attribute :status
  attribute :biography
  attribute :accepting_patient
  attribute :enable_online_booking
  attribute :profile_image
end
