class Employer
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :name,           type: String
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
