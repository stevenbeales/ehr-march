class Surface
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :mesial,       type: Boolean
  field :incisal,      type: Boolean
  field :distal,       type: Boolean
  field :lingual,      type: Boolean
  field :facial,       type: Boolean
  field :class_five,   type: Boolean

  belongs_to :procedure

  def get_all_true_fields
    surfaces = []
    surfaces << 'mesial'     if mesial
    surfaces << 'incisal'    if incisal
    surfaces << 'distal'     if distal
    surfaces << 'lingual'    if lingual
    surfaces << 'facial'     if facial
    surfaces << 'class five' if class_five
    surfaces.join(', ')
  end
end
