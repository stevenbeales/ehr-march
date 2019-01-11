class State
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :abbr
  field :name

  has_many :zipcodes
  has_many :counties

  def cities
    zipcodes.pluck(:city).sort.uniq
  end
end
