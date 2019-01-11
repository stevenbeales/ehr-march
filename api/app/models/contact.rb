class Contact
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :favorite, type: Boolean,  default: false

  belongs_to :provider
  belongs_to :practice
end
