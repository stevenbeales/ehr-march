class AreaCode
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :code, type: Integer
  field :city, type: String
end