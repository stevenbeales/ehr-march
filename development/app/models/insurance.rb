class Insurance
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.relations
    [
        :'Associate',
        :'Brother',
        :'Care giver',
        :'Child',
        :'Emergency contact',
        :'Employee',
        :'Employer',
        :'Extended family',
        :'Father',
        :'Foster child',
        :'Friend',
        :'Grandchild',
        :'Grandparent',
        :'Guardian',
        :'Handicapped dependent',
        :'Life partner',
        :'Manager',
        :'Mother',
        :'Natural child',
        :'None',
        :'Other',
        :'Other adult',
        :'Owner',
        :'Parent',
        :'Self',
        :'Sibling',
        :'Sister',
        :'Spouse',
        :'Stepchild',
        :'Trainer',
        :'Unknown',
        :'Ward of court'
    ]
  end

  def self.copay_types
    [:'$', :'%']
  end

  field :worker_compensation, type: Boolean, default: false
  field :insurance_number,    type: String
  field :relation,            type: Enum,    in: self.relations,   default: self.relations.first
  field :effective_from,      type: Time
  field :effective_to,        type: Time
  field :copay_type,          type: Enum,    in: self.copay_types, default: self.copay_types.first
  field :copay_amount,        type: Float
  field :claim,               type: Integer
  field :note,                type: Text
  field :active,              type: Boolean

  has_one :employer,   dependent: :destroy
  has_one :subscriber, dependent: :destroy
  belongs_to :patient
  belongs_to :provider
  belongs_to :payer
end