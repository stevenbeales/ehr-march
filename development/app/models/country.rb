class Country
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :abbr
  field :name
  field :country_seat

  has_many    :zipcodes
  belongs_to  :state
end
