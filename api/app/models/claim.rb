class Claim
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :first_name,        type: String
  field :middle_name,       type: String
  field :last_name,         type: String
  field :street_address1,   type: String
  field :street_address2,   type: String
  field :phone,             type: String
  field :fax,               type: String
  field :ext1,              type: String
  field :ext2,              type: String
  field :city,              type: String
  field :state,             type: String
  field :zip,               type: Integer
  field :notes,             type: Text

  belongs_to :payer

  before_validation :phony_normalize

  private

  def phony_normalize
    self.phone = PhonyRails.normalize_number(phone, default_country_code: 'US')
    self.fax   = PhonyRails.normalize_number(fax,   default_country_code: 'US')
  end
end