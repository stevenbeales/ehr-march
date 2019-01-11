FactoryGirl.define do
  factory :user, class: User do
    email                  { Faker::Internet.email }
    password              'doctor'
    password_confirmation 'doctor'
    role                  :Provider
    captcha               111111
    locked                false
    confirmed_at          { Time.now }
    remember_created_at   { Time.now }
    authy_id              { nil }
    authy_enabled         { false }
  end
end
