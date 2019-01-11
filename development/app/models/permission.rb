class Permission
  include NoBrainer::Document

  field :presentation,    type: String
  field :policy_name,     type: String

  has_many   :availabilities,     dependent: :destroy
  belongs_to :provider
end
