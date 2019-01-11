class Permission
  include NoBrainer::Document

  field :presentation,    type: String
  field :policy_name,     type: String

  belongs_to :provider
  has_many   :availabilities,     dependent: :destroy
end
