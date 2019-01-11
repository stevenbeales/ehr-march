class ToothField
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.field_names
    %w(Pd Gm Cal Mgl)
  end

  field :field_name,   type: String
  field :b1,           type: Integer, default: 0
  field :b2,           type: Integer, default: 0
  field :b3,           type: Integer, default: 0
  field :b_bsp1,       type: Boolean, default: false
  field :b_bsp2,       type: Boolean, default: false
  field :b_bsp3,       type: Boolean, default: false
  field :b_bsp4,       type: Boolean, default: false
  field :b_bsp5,       type: Boolean, default: false
  field :b_bsp6,       type: Boolean, default: false
  field :b_bsp7,       type: Boolean, default: false
  field :b_bsp8,       type: Boolean, default: false
  field :b_bsp9,       type: Boolean, default: false
  field :l1,           type: Integer, default: 0
  field :l2,           type: Integer, default: 0
  field :l3,           type: Integer, default: 0
  field :l_bsp1,       type: Boolean, default: false
  field :l_bsp2,       type: Boolean, default: false
  field :l_bsp3,       type: Boolean, default: false
  field :l_bsp4,       type: Boolean, default: false
  field :l_bsp5,       type: Boolean, default: false
  field :l_bsp6,       type: Boolean, default: false
  field :l_bsp7,       type: Boolean, default: false
  field :l_bsp8,       type: Boolean, default: false
  field :l_bsp9,       type: Boolean, default: false

  belongs_to :tooth_table

  before_update :prevent_update
  after_create  :set_field_name

  private

  def prevent_update
    return true if tooth_table.active
    self.errors[:base] << "Cannot be updated, disabled tooth."
    false
  end

  def set_field_name
    self.update(field_name: self.class.name)
  end
end
