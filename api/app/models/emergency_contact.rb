class EmergencyContact
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.relations
    [:Parent, :Child, :Wife]
  end

  field :first_name,                  type: String
  field :middle_name,                 type: String
  field :last_name,                   type: String
  field :relation,                    type: Enum,     in: self.relations,  default: self.relations.first
  field :mobile_phone,                type: String
  field :email,                       type: String
  field :street_address,              type: String
  field :city,                        type: String
  field :state,                       type: String
  field :zip,                         type: Integer

  belongs_to :patient

  before_validation :phony_normalize

  private

  def phony_normalize
    self.mobile_phone  = PhonyRails.normalize_number(mobile_phone,  default_country_code: 'US')
  end
end
