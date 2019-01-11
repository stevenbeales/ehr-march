class Referral
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.specialities
    Provider.specialities
  end

  field :normal,         type: String
  field :middle_name,    type: String
  field :last_name,      type: String
  field :individual_npi, type: String
  field :speciality,     type: Enum,         in: self.specialities,      default: self.specialities.first
  field :phone,          type: String
  field :fax,            type: String
  field :email,          type: String

  belongs_to :appointment
  belongs_to :provider

  before_validation :phony_normalize

  def full_name
    "#{normal} #{last_name}"
  end

  private

  def phony_normalize
    self.phone = PhonyRails.normalize_number(phone,  default_country_code: 'US')
    self.fax   = PhonyRails.normalize_number(fax,   default_country_code: 'US')
  end
end
