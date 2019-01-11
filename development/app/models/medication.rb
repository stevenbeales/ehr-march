class Medication
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :shorthand,       type: String
  field :signature,       type: Text
  field :start_date,      type: Time
  field :stop_date,       type: Time
  field :note,            type: Text

  belongs_to :diagnosis
  belongs_to :portion
end
