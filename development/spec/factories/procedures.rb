FactoryGirl.define do
  factory :procedure do
    tooth_table_id    { nil }
    procedure_code    { PROCEDURE_CODES.keys.sample.to_s }
    description       { PROCEDURE_CODES.values.sample.to_s }
    date_of_service   { Time.now }
    status            { Procedure.statuses.sample }
  end
end
