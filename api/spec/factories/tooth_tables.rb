# == Schema Information
#
# Table name: tooth_tables
#
#  id         :integer          not null, primary key
#  patient_id :integer
#  tooth_num  :integer
#  fm_f       :integer          default(0)
#  fm_m       :integer          default(0)
#  b_bsp1     :boolean          default(FALSE)
#  b_bsp2     :boolean          default(FALSE)
#  b_bsp3     :boolean          default(FALSE)
#  b_bsp4     :boolean          default(FALSE)
#  b_bsp5     :boolean          default(FALSE)
#  b_bsp6     :boolean          default(FALSE)
#  b_bsp7     :boolean          default(FALSE)
#  b_bsp8     :boolean          default(FALSE)
#  b_bsp9     :boolean          default(FALSE)
#  l_bsp1     :boolean          default(FALSE)
#  l_bsp2     :boolean          default(FALSE)
#  l_bsp3     :boolean          default(FALSE)
#  l_bsp4     :boolean          default(FALSE)
#  l_bsp5     :boolean          default(FALSE)
#  l_bsp6     :boolean          default(FALSE)
#  l_bsp7     :boolean          default(FALSE)
#  l_bsp8     :boolean          default(FALSE)
#  l_bsp9     :boolean          default(FALSE)
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :tooth_table do

  end

end
