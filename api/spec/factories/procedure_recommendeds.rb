FactoryGirl.define do
  factory :procedure_recommended do
    association    :encounter
    procedure_code { PROCEDURE_CODES.to_a.sample[0].to_s }
  end
end
