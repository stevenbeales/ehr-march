require 'jsonapi-serializers'

class ProcedureSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :tooth_table_id
  attribute :procedure_code
  attribute :description
  attribute :date_of_service
  attribute :status
end
