class Patient
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CarrierWave::NoBrainer
  include AdminNotifier

  def self.genders
    [:Male, :Female, :Other]
  end

  def self.preferred_languages
    [
      :'English', :'Spanish', :'German', :'Russian', :'Preferred Language'
    ]
  end

  def self.ethnicities
    [:'Hispanic of Latino', :'Not Hispanic of Latino', :'Patient declined to specify']
  end

  def self.immunization_registries
    [:NotSend, :Send, :NotSpecified]
  end

  field :first_name,                  type: String
  field :middle_name,                 type: String
  field :last_name,                   type: String
  field :birth,                       type: Time
  field :gender,                      type: Enum,         in: self.genders,                 default: self.genders.first
  field :mobile_phone,                type: String
  field :primary_phone,               type: String
  field :code,                        type: Integer
  field :social_number,               type: String
  field :active,                      type: Boolean,                                        default: true
  field :declined_portal_access,      type: Boolean
  field :preferred_language,          type: String
  field :ethnicity,                   type: Enum,         in: self.ethnicities,             default: self.ethnicities.first
  field :american_race,               type: Boolean
  field :asian_race,                  type: Boolean
  field :african_race,                type: Boolean
  field :hawaiian_race,               type: Boolean
  field :white_race,                  type: Boolean
  field :undetermined_race,           type: Boolean
  field :email_reminder,              type: Boolean
  field :sms_reminder,                type: Boolean
  field :immunization_registry,       type: Enum,         in: self.immunization_registries, default: self.immunization_registries.first
  field :work_phone,                  type: String
  field :ext,                         type: String
  field :street_address,              type: String
  field :city,                        type: String
  field :state,                       type: String
  field :zip,                         type: Integer
  field :profile_image,               type: String
  mount_uploader :profile_image, ImageUploader

  belongs_to :user
  belongs_to :provider
  has_many   :patient_appointments
  has_many   :appointments
  has_many   :block_outs, dependent: :destroy

  has_many :emergency_contacts, dependent: :destroy
  has_one  :next_kin, dependent: :destroy
  has_one  :guarantor
  has_many :payers

  has_many :tooth_tables, dependent: :destroy

  has_many :diagnoses, dependent: :destroy
  # has_many :medications, dependent: :destroy
  has_many :allergies, dependent: :destroy
  has_many :insurances, dependent: :destroy
  has_many :smoking_statuses, dependent: :destroy
  has_one  :past_medical_history, dependent: :destroy
  has_one  :advanced_directive, dependent: :destroy

  has_many :encounters, dependent: :destroy
  has_many :text_messages
  has_many :email_messages

  before_validation :phony_normalize
  after_create  :create_emergency_contact_and_next_kin, :create_teeth
  after_create  :send_create_sms
  after_update  :send_update_sms

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def phony_normalize
    self.mobile_phone  = PhonyRails.normalize_number(mobile_phone,  default_country_code: 'US')
    self.primary_phone = PhonyRails.normalize_number(primary_phone, default_country_code: 'US')
    self.work_phone    = PhonyRails.normalize_number(work_phone,    default_country_code: 'US')
  end

  def create_emergency_contact_and_next_kin
    FactoryGirl.create(:emergency_contact,    patient_id: id)
    FactoryGirl.create(:next_kin,             patient_id: id)
    FactoryGirl.create(:guarantor,            patient_id: id)

    FactoryGirl.create(:advanced_directive,   patient_id: id)
    FactoryGirl.create(:past_medical_history, patient_id: id)
    FactoryGirl.create(:smoking_status,       patient_id: id)
  end

  def create_teeth
    32.times do |i|
      tooth_table = ToothTable.create(patient_id: id, tooth_num: i + 1)
      Mgl.create tooth_table_id: tooth_table.id
      Cal.create tooth_table_id: tooth_table.id
      Gm.create  tooth_table_id: tooth_table.id
      Pd.create  tooth_table_id: tooth_table.id
    end
  end

  def send_create_sms
    body = "New patient #{full_name} was created"
    TextMessage.create(to: provider.try(:primary_phone), body: body)
  end

  def send_update_sms
    body = "Patient #{full_name} was updated"
    TextMessage.create(to: provider.try(:primary_phone), body: body)
  end
end
