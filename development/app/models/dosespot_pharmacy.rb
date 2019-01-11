class DosespotPharmacy
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  # field :pharmacy_code,               type: Integer,                  require: true
  # field :store_name,                  type: String,  max_length: 500, require: true
  # field :first_address,               type: String,  max_length: 35,  require: true
  # field :second_address,              type: String,  max_length: 35
  # field :city,                        type: String,  max_length: 35,  require: true
  # field :state,                       type: String,  max_length: 20,  require: true
  # field :zip,                         type: String,  max_length: 10,  require: true
  # field :primary_phone,               type: String,  max_length: 35,  require: true
  # field :mobile_phone,                type: String,  max_length: 25,  require: true

  # belongs_to :dosespot
end
