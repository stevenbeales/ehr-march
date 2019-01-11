class DiagnosisCode
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field  :code,             type: String
  field  :description,      type: String

  has_many :diagnoses
end
