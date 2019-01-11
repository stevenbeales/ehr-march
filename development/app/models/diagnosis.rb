class Diagnosis
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :start_date,      type: Time
  field :stop_date,       type: Time
  field :acute,           type: Boolean
  field :terminal,        type: Boolean
  field :note,            type: Text

  has_many   :medications
  belongs_to :patient
  belongs_to :diagnosis_code
end
