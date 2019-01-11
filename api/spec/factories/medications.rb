FactoryGirl.define do
  factory :medication do
    association   :diagnosis
    association   :portion
    shorthand     { Faker::Hipster.word.capitalize }
    signature     { Faker::Internet.password(16) }
    start_date    { Time.now - 1.hour }
    stop_date     { Time.now + 1.hour }
    note          { Faker::Lorem.sentence }
  end
end
