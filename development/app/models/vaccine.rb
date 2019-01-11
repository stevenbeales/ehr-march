class Vaccine
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :name,           type: String
  field :trade_name,     type: String
  field :abbreviation,   type: String
  field :manufacturer,   type: String
  field :route,          type: String
  field :approved,       type: Integer
  field :comment,        type: String
  field :second_comment, type: String

  has_many :immunizations
end