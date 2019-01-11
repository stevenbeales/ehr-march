class Vital
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.temp_types
    [
        :'Unspecified',
        :'Axillary',
        :'Oral',
        :'Rectal',
        :'Skin',
        :'Temporal',
        :'Tympanic'
    ]
  end

  def self.ra_types
    [
        :'RA',
        :'0.5 LO2',
        :'1.0 LO2',
        :'1.5 LO2',
        :'2.0 LO2',
        :'2.5 LO2',
        :'3.0 LO2',
        :'>3.0 LO2'
    ]
  end

  def self.units_systems
    [:us, :euro]
  end

  field :height_major, type: Integer
  field :height_minor, type: Integer
  field :weight,       type: Float
  field :bmi,          type: Float
  field :units_system, type: Enum,      in: self.units_systems, default: self.units_systems.first
  field :bp_left,      type: String
  field :bp_right,     type: String
  field :temp,         type: String
  field :pulse,        type: String
  field :rr,           type: String
  field :sat,          type: String
  field :temp_type,    type: Enum,      in: self.temp_types,    default: self.temp_types.first
  field :ra_type,      type: Enum,      in: self.ra_types,      default: self.ra_types.first
  field :blood,        type: String

  belongs_to :encounter

  after_create :set_bmi

  private

  def set_bmi
    if weight.present? && height_major.present? && height_minor.present?
      update(bmi: (weight * 703) / ((height_minor * (units_system == :euro ? 100 : 12) + height_major)**2))
    end
  end
end
