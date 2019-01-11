FactoryGirl.define do
  factory :portion do
    drug          { Faker::Lorem.word.capitalize }
    dose          { "#{Faker::Number.number(3)} mg." }
    instruction   { Faker::Hipster.sentence }
  end
end
