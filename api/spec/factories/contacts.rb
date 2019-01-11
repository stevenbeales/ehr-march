FactoryGirl.define do
  factory :contact do
    association  :provider
    favorite     { false }
  end
end
