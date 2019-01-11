FactoryGirl.define do
  factory :zipcode do
    code        "MyString"
    city        "MyString"
    state       nil
    county_id   1
    area_code   "MyString"
    lat         "9.99"
    lon         "9.99"
  end
end
