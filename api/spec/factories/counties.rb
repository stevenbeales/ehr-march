# == Schema Information
#
# Table name: counties
#
#  id          :integer          not null, primary key
#  state_id    :integer
#  abbr        :string(255)
#  name        :string(255)
#  county_seat :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_counties_on_name      (name)
#  index_counties_on_state_id  (state_id)
#

FactoryGirl.define do
  factory :county do
    state nil
    abbr "MyString"
    name "MyString"
    county_seat "MyString"
  end

end
