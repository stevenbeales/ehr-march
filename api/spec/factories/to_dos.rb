# == Schema Information
#
# Table name: to_dos
#
#  id             :integer          not null, primary key
#  appointment_id :integer
#  done           :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :to_do do
  end

end
