require 'jsonapi-serializers'

class ToothTableSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :patient_id

  attribute :tooth_num
  attribute :fm_f
  attribute :fm_m

  attribute :b_bsp1
  attribute :b_bsp2
  attribute :b_bsp3
  attribute :b_bsp4
  attribute :b_bsp5
  attribute :b_bsp6
  attribute :b_bsp7
  attribute :b_bsp8
  attribute :b_bsp9
  attribute :l_bsp1
  attribute :l_bsp2
  attribute :l_bsp3
  attribute :l_bsp4
  attribute :l_bsp5
  attribute :l_bsp6
  attribute :l_bsp7
  attribute :l_bsp8
  attribute :l_bsp9

  attribute :active
end