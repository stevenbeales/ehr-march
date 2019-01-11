class Room
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :room, type: String

  belongs_to :provider
  has_many   :appointments
end
