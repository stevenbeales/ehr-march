FactoryGirl.define do
  factory :patient do
    first_name     { Faker::Name.first_name }
    last_name      { Faker::Name.last_name  }
    birth          { Time.now - 10.year }
    association    :user, role: :Patient
    mobile_phone   { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    primary_phone  { PhonyRails.normalize_number(Faker::PhoneNumber.cell_phone, country_code: 'US') }
    social_number  { (1..9).map{"123456789".chars.to_a.sample}.join }
    provider_id    nil
    active         true
    profile_image  { File.open(Rails.root.join('app', 'assets', 'images', 'admin', "avatar#{(1..11).to_a.sample}.jpg")) }
  end
end
