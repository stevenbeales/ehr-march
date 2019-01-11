# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  abbr       :string(2)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_states_on_abbr  (abbr)
#

FactoryGirl.define do
  factory :state do
    abbr "MyString"
    name "MyString"
  end

end
