class Cusp
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :mesiobuccal,    type: Boolean
  field :mesiolingual,   type: Boolean
  field :distobuccal,    type: Boolean
  field :distolingual,   type: Boolean

  belongs_to :procedure
end
