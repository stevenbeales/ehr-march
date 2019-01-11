class Guarantor
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.genders
    [:Male, :Female, :Other]
  end

  def self.relations
    [:Wife, :Husband, :Friend]
  end

  field :first_name,     type: String
  field :middle_name,    type: String
  field :last_name,      type: String
  field :birth,          type: Time
  field :gender,         type: Enum,    in: self.genders,   default: self.genders.first
  field :social_number,  type: String
  field :relation,       type: Enum,    in: self.relations, default: self.relations.first
  field :phone,          type: String
  field :email,          type: String
  field :street_address, type: String
  field :city,           type: String
  field :state,          type: String
  field :zip,            type: Integer

  belongs_to :patient

  before_validation :phony_normalize

  private

  def phony_normalize
    self.phone = PhonyRails.normalize_number(phone,  default_country_code: 'US')
  end
end
