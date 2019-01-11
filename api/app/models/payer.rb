class Payer
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.plan_types
    [:Type1, :Type2, :Type3, :Type4, :Type5]
  end

  field :name,       type: String
  field :plan,       type: String
  field :plan_type,  type: Enum,    in: self.plan_types, default: self.plan_types.first

  belongs_to :patient
  has_one    :claim,        dependent: :destroy
  has_many   :insurances
end