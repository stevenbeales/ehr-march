class Country
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :abbr
  field :name
  field :country_seat

  belongs_to :state
  has_many :zipcodes

  # def cities
  #   zipcodes.pluck(:city).sort.uniq
  # end
end
