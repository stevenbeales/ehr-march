class Allergy
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.allergen_types
    [:Drug, :Food, :Environment]
  end

  def self.severity_levels
    [:'Very Mild', :Mild, :Moderate, :Severe]
  end

  def self.onset_ats
    [:Childhood, :Adulthood, :Unkhown]
  end

  field :allergen_type,    type: Enum,     in: self.allergen_types,    default: self.allergen_types.first
  field :severity_level,   type: Enum,     in: self.severity_levels,   default: self.severity_levels.first
  field :onset_at,         type: Enum,     in: self.onset_ats,         default: self.onset_ats.first
  field :start_date,       type: Time
  field :active,           type: Boolean
  field :note,             type: Text

  belongs_to :patient
end
