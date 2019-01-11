class PastMedicalHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :major_events,           type: Text
  field :ongoing_problems,       type: Text
  field :preventitive_care,      type: Text
  field :nutrition_history,      type: Text
  field :developmental_history,  type: Text

  belongs_to :patient
end
