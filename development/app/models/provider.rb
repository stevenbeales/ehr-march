class Provider
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CarrierWave::NoBrainer
  include AdminNotifier

  def self.titles
    [:Mr, :Ms, :Dr]
  end

  def self.degrees
    [
      :'DDS',
      :'DMD',
      :'MD',
      :'DO',
      :'RDH',
      :'N/A Degree'
    ]
  end

  def self.specialities
    [
      :'Endodontics',
      :'Oral and Maxillofacial Pathology',
      :'Oral and Maxillofacial Radiology',
      :'Oral and Maxillofacial Surgery',
      :'Orthodontics and Dentofacial Orthopedics',
      :'Pediatric Dentistry',
      :'Periodontics',
      :'Prosthodontics',
      :'N/A Speciality'
    ]
  end

  def self.practice_roles
    [:Provider, :Dentist, :Hygientist, :'Back Office', :'Front Desk']
  end

  field :title,                       type: Enum,         in: self.titles,         default: self.titles.first
  field :first_name,                  type: String
  field :middle_name,                 type: String
  field :last_name,                   type: String
  field :practice_role,               type: Enum,         in: self.practice_roles, default: self.practice_roles[1]
  field :degree,                      type: Enum,         in: self.degrees,        default: self.degrees.first
  field :speciality,                  type: Enum,         in: self.specialities,   default: self.specialities.first
  field :street_address,              type: String
  field :suit_apt_number,             type: String
  field :city,                        type: String
  field :state,                       type: String
  field :zip,                         type: Integer
  field :practice_street_address,     type: String
  field :practice_suit_apt_number,    type: String
  field :practice_city,               type: String
  field :practice_state,              type: String
  field :practice_zip,                type: Integer
  field :primary_phone,               type: String
  field :mobile_phone,                type: String
  field :alt_email,                   type: String
  field :username,                    type: String
  field :secondary_speciality,        type: String
  field :dental_licence,              type: String
  field :expiration_date,             type: Time
  field :ein_tin,                     type: String
  field :npi,                         type: String
  field :dea,                         type: String
  field :upin,                        type: String
  field :nadean,                      type: String
  field :status,                      type: Boolean,      default: false
  field :admin,                       type: Boolean,      default: false
  field :emergency_access,            type: Boolean,      default: false
  field :emergency_access_reason,     type: String
  field :biography,                   type: Text
  field :accepting_patient,           type: Boolean,      default: false
  field :enable_online_booking,       type: Boolean,      default: false
  field :profile_image,               type: String
  field :dosespot_user_id,            type: Integer
  mount_uploader :profile_image, ImageUploader

  has_many    :patients
  has_many    :providers
  has_many    :appointments
  has_many    :referrals
  has_many    :rooms,                 dependent: :destroy
  has_many    :appointment_types,     dependent: :destroy
  has_many    :appointment_statuses,  dependent: :destroy
  has_many    :patient_appointments
  has_many    :practice_locations,    class_name: 'Location'
  has_many    :encounters
  has_many    :text_messages
  has_many    :email_messages
  has_many    :insurances
  has_many    :contacts
  has_many    :permissions,           dependent: :destroy
  has_one     :schedule_general,      dependent: :destroy
  belongs_to  :user
  belongs_to  :provider
  belongs_to  :practice_location,     class_name: 'Location'

  alias_method :admin?, :admin

  before_validation :phony_normalize
  after_create  :create_settings
  after_create  :send_create_sms
  after_create  :create_permission_list, if: Proc.new { practice_role == :Provider }
  after_update  :send_update_sms

  def to_label
    "#{title}" + ' ' "#{last_name}" + ' ' "#{first_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def location1
    "#{street_address}, #{suit_apt_number}, #{city}, #{state}"
  end

  def location2
    "#{practice_street_address}, #{practice_suit_apt_number}, #{practice_city}, #{practice_state}"
  end

  def locations
    [location1, location2]
  end

  def create_settings
    FactoryGirl.create :schedule_general, provider_id: id
  end

  def all_patients
    if practice_role == :Provider
      patients
    else
      provider.patients
    end
  end

  def all_providers
    if practice_role == :Provider
      providers.to_a.dup.push(self)
    else
      provider.providers.to_a.dup.push(provider)
    end
  end

  def all_practice_locations
    if practice_role == :Provider
      practice_locations
    else
      provider.practice_locations
    end
  end

  def all_permissions
    if practice_role == :Provider
      permissions
    else
      provider.permissions
    end
  end

  def main_provider_id
    if practice_role == :Provider
      id
    else
      provider.id
    end
  end

  def dosespot_id
    if practice_role == :Provider
      dosespot_user_id
    else
      provider.dosespot_user_id
    end
  end

  private

  def phony_normalize
    self.primary_phone = PhonyRails.normalize_number(primary_phone, default_country_code: 'US')
    self.mobile_phone  = PhonyRails.normalize_number(mobile_phone,  default_country_code: 'US')
  end

  def send_create_sms
    body = "New provider #{full_name} was created"
    TextMessage.create(to: primary_phone, body: body)
  end

  def send_update_sms
    body = "Provider #{full_name} was updated"
    TextMessage.create(to: primary_phone, body: body)
  end

  def create_permission_list
    PermissionCsv.set_default_permissions_from_csv(self)
  end
end
