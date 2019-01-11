class ToDo
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :done, type: Boolean, default: false

  belongs_to :appointment
end
