class Pit
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :mesial,         type: Boolean
  field :mesiobuccal,    type: Boolean
  field :mesiolingual,   type: Boolean
  field :distal,         type: Boolean
  field :distobuccal,    type: Boolean
  field :distolingual,   type: Boolean

  belongs_to :procedure
end
