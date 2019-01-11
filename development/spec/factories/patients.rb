FactoryGirl.define do
  factory :patient do
    first_name     { Faker::Name.first_name }
    middle_name    { Faker::Name.first_name }
    last_name      { Faker::Name.last_name  }
    birth          { Time.now - 10.year }
    association    :user, role: :Patient
    street_address { '712 Main Street' }
    mobile_phone   { '+17817215566' }
    primary_phone  { '+17813869851' }
    social_number  { (1..9).map{"123456789".chars.to_a.sample}.join }
    city           { 'Holtsville' }
    state          { 'New York' }
    zip            { 501 }
    provider_id    nil
    active         true
    profile_image  { File.open(Rails.root.join('app', 'assets', 'images', 'admin', "avatar#{(1..11).to_a.sample}.jpg")) }
  end
end
