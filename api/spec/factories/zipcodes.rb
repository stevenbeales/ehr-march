# == Schema Information
#
# Table name: zipcodes
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  city       :string(255)
#  state_id   :integer
#  county_id  :integer
#  area_code  :string(255)
#  lat        :decimal(15, 10)
#  lon        :decimal(15, 10)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_zipcodes_on_code         (code)
#  index_zipcodes_on_county_id    (county_id)
#  index_zipcodes_on_lat_and_lon  (lat,lon)
#  index_zipcodes_on_state_id     (state_id)
#

FactoryGirl.define do
  factory :zipcode do
    code "MyString"
    city "MyString"
    state nil
    county_id 1
    area_code "MyString"
    lat "9.99"
    lon "9.99"
  end

end
