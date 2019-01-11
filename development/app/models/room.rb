class Room
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :room, type: String

  has_many   :appointments
  belongs_to :provider
end
