class Dosespot
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :prefix,                      type: String, max_length: 35
  field :first_name,                  type: String, max_length: 35,      validates: { format: { with: /\A[A-Z][a-z]+\z/ } }
  field :middle_name,                 type: String, max_length: 35,      validates: { format: { with: /\A[A-Z][a-z][A-z\-]+\z/ } }
  field :last_name,                   type: String, max_length: 35,      validates: { format: { with: /\A[A-Z][a-z][A-z\-]+\z/ } }
  field :suffix,                      type: String, max_length: 35
  field :birth,                       type: String
  field :gender,                      type: String, in: %w(Male Female Other)
  field :social_number,               type: String, max_length: 35 # ,   validates: { format: { with: /\A[0-9A-z\-.\/ ]+\z/ } }
  field :first_address,               type: String, max_length: 35 # ,   validates: { format: { with: /\A[0-9A-z\-.\/ ]+\z/ } }  # require
  field :second_address,              type: String, max_length: 35 # ,   validates: { format: { with: /\A[0-9A-z\-.\/ ]+\z/ } }
  field :city,                        type: String, max_length: 50      # require
  field :state,                       type: String, max_length: 50      # require
  field :zip,                         type: String # , length: { is: 5 }   # require
  field :primary_phone,               type: String # , length: { is: 10 }  # require
  field :mobile_phone,                type: String # , length: { is: 10 }

  # has_many   :dosespot_pharmacies
  belongs_to :patient

  def url
    phrase = SecureRandom.base64(24)
    secrets = Rails.application.secrets

    url =  "#{ secrets.dose_server }/"
    url << "#{ secrets.dose_url }?"
    url << "#{ secrets.dose_b_param }=#{ secrets.dose_b }"
    url << "&#{ secrets.dose_clinic_id_param }=#{ secrets.dose_clinic_id }"
    url << "&#{ secrets.dose_user_id_param }=#{ user_id }"
    url << "&#{ secrets.dose_phrase_length_param }=#{ secrets.dose_phrase_length }"
    url << "&#{ secrets.dose_code_param }=#{ code(phrase) }"
    url << "&#{ secrets.dose_user_id_verify_param }=#{ verify(phrase) }"
    url << "&#{ secrets.dose_prefix_param }=#{ prefix }"
    url << "&#{ secrets.dose_first_name_param }=#{ first_name }"
    url << "&#{ secrets.dose_middle_name_param }=#{ middle_name }"
    url << "&#{ secrets.dose_last_name_param }=#{ last_name }"
    url << "&#{ secrets.dose_suffix_param }=#{ suffix }"
    url << "&#{ secrets.dose_birth_param }=#{ birth }"
    url << "&#{ secrets.dose_gender_param }=#{ gender }"
    url << "&#{ secrets.dose_first_address_param }=#{ first_address }"
    url << "&#{ secrets.dose_second_address_param }=#{ second_address }"
    url << "&#{ secrets.dose_city_param }=#{ city }"
    url << "&#{ secrets.dose_state_param }=#{ state }"
    url << "&#{ secrets.dose_zipcode_param }=#{ zip }"
    url << "&#{ secrets.dose_primary_phone_param }=#{ primary_phone }"
    url << "&#{ secrets.dose_primary_phone_type_param }=#{ secrets.dose_primary_phone_type }"
    url << "&#{ secrets.dose_first_phone_additional_param }=#{ mobile_phone }"
    url << "&#{ secrets.dose_first_phone_additional_type_param }=#{ secrets.dose_first_phone_additional_type }"
    url << "&#{ secrets.dose_pharmacy_id_param }=#{ secrets.dose_pharmacy_id }"
    url.html_safe
  end

  def valid_url?
    required_fields.each do |field|
      return false if send(field).blank?
    end
    true
  end

  def full_message
    required_fields.map { |field| "#{field} is required" if send(field).blank? }.reject{ |message| message.blank? }.to_sentence
  end

  def required_fields
    [:first_name, :last_name, :birth, :gender, :first_address, :city, :state, :zip, :primary_phone]
  end

  def code(phrase)
    key = Rails.application.secrets.dose_clinic_key
    CGI.escape(phrase + remove_extra_equals_signs(Digest::SHA2.new(512).base64digest(phrase + key)))
  end

  def remove_extra_equals_signs(digest)
    digest[-1] == digest[-2] ? digest[0..-3] : digest
  end

  def verify(phrase)
    key = Rails.application.secrets.dose_clinic_key
    CGI.escape(remove_extra_equals_signs(Digest::SHA2.new(512).base64digest(user_id + phrase[0..21] + key)))
  end

  def user_id
    patient.try(:provider).try(:dosespot_user_id).to_s
  end
end
