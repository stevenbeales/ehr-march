class EmailMessage
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :to_id,                   type: String
  field :from_id,                 type: String
  field :body,                    type: Text
  field :draft,                   type: Boolean,    default: true
  field :archive,                 type: Boolean,    default: false
  field :urgent,                  type: Boolean,    default: true
  field :read,                    type: Boolean,    default: false

  belongs_to :subject
  belongs_to :to,       foreign_key: :to_id,   class_name: :User
  belongs_to :from,     foreign_key: :from_id, class_name: :User

  # attachment :attachment
end
