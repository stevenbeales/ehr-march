class ToothTable
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many    :tooth_fields, dependent: :destroy
  has_many    :procedures
  belongs_to  :patient

  before_update :prevent_update

  field :tooth_num, type: Integer
  field :fm_f,      type: Integer
  field :fm_m,      type: Integer

  field :b_bsp1,    type: Boolean, default: false
  field :b_bsp2,    type: Boolean, default: false
  field :b_bsp3,    type: Boolean, default: false
  field :b_bsp4,    type: Boolean, default: false
  field :b_bsp5,    type: Boolean, default: false
  field :b_bsp6,    type: Boolean, default: false
  field :b_bsp7,    type: Boolean, default: false
  field :b_bsp8,    type: Boolean, default: false
  field :b_bsp9,    type: Boolean, default: false
  field :l_bsp1,    type: Boolean, default: false
  field :l_bsp2,    type: Boolean, default: false
  field :l_bsp3,    type: Boolean, default: false
  field :l_bsp4,    type: Boolean, default: false
  field :l_bsp5,    type: Boolean, default: false
  field :l_bsp6,    type: Boolean, default: false
  field :l_bsp7,    type: Boolean, default: false
  field :l_bsp8,    type: Boolean, default: false
  field :l_bsp9,    type: Boolean, default: false

  field :active,    type: Boolean, default: true

  def mgl
    tooth_fields.where(field_name: 'Mgl').first
  end

  def cal
    tooth_fields.where(field_name: 'Cal').first
  end

  def gm
    tooth_fields.where(field_name: 'Gm').first
  end

  def pd
    tooth_fields.where(field_name: 'Pd').first
  end

  private

  def prevent_update
    return true if active || active_changed?
    self.errors[:base] << "Cannot update disabled tooth."
    false
  end
end
