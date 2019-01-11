class AdvancedDirective
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :record_date,  type: Time
  field :notes,        type: Text

  belongs_to :patient
end