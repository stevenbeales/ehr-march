# == Schema Information
#
# Table name: tooth_fields
#
#  id             :integer          not null, primary key
#  tooth_table_id :integer
#  field_name     :string(255)
#  b1             :integer
#  b2             :integer
#  b3             :integer
#  b_bsp1         :boolean          default(FALSE)
#  b_bsp2         :boolean          default(FALSE)
#  b_bsp3         :boolean          default(FALSE)
#  b_bsp4         :boolean          default(FALSE)
#  b_bsp5         :boolean          default(FALSE)
#  b_bsp6         :boolean          default(FALSE)
#  b_bsp7         :boolean          default(FALSE)
#  b_bsp8         :boolean          default(FALSE)
#  b_bsp9         :boolean          default(FALSE)
#  l1             :integer
#  l2             :integer
#  l3             :integer
#  l_bsp1         :boolean          default(FALSE)
#  l_bsp2         :boolean          default(FALSE)
#  l_bsp3         :boolean          default(FALSE)
#  l_bsp4         :boolean          default(FALSE)
#  l_bsp5         :boolean          default(FALSE)
#  l_bsp6         :boolean          default(FALSE)
#  l_bsp7         :boolean          default(FALSE)
#  l_bsp8         :boolean          default(FALSE)
#  l_bsp9         :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :tooth_field do

  end

end
