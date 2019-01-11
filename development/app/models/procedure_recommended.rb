class ProcedureRecommended
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :procedure_code, type: String

  belongs_to :encounter
end
