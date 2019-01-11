FactoryGirl.define do
  factory :email_message do
    association :subject
    to_id      { nil }
    from_id    { nil }

    body       { Faker::Lorem.sentence }
    draft      false
    archive    false
    urgent     false
    read       false

    factory :draft do
      draft    true
    end

    factory :urgent do
      urgent   true
    end

    factory :archive do
      archive  true
    end
  end
end
