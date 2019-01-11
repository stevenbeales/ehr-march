class Representative
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :first_name,       type: String
  field :last_name,        type: String
  field :primary_phone,    type: String
  field :active,           type: Boolean,    default: false

  belongs_to :patient
  belongs_to :user
end
