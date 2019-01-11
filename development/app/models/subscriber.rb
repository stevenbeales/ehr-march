class Subscriber
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.genders
    [:Male, :Female, :Other]
  end

  field :first_name,     type: String
  field :middle_name,    type: String
  field :last_name,      type: String
  field :birth,          type: Time
  field :gender,         type: Enum,  in: self.genders, default: self.genders.first
  field :social_number,  type: String
  field :phone,          type: String
  field :street_address, type: String
  field :city,           type: String
  field :state,          type: String
  field :zip,            type: Integer

  belongs_to :insurance

  before_validation :phony_normalize

  private

  def phony_normalize
    self.phone = PhonyRails.normalize_number(phone,  default_country_code: 'US')
  end
end
