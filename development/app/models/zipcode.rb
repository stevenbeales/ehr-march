class Zipcode
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :code
  field :city
  field :state_id
  field :county_id
  field :area_code
  field :lat
  field :lon

  belongs_to :country
  belongs_to :state
end
