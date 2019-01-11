class Encounter
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :notes,             type: Text
  field :med_completed,     type: Boolean
  field :patient_education, type: Boolean
  field :clinical_summary,  type: Boolean
  field :to_provider_id,    type: String
  field :from_provider_id,  type: String

  has_many   :procedures
  has_many   :procedure_completeds, dependent: :destroy
  has_many   :procedure_recommendeds, dependent: :destroy
  has_one    :vital, dependent: :destroy
  belongs_to :provider
  belongs_to :patient
  belongs_to :referred_to,   foreign_key: :to_provider_id,   class_name: 'Provider'
  belongs_to :referred_from, foreign_key: :from_provider_id, class_name: 'Provider'

  after_create :send_create_sms
  after_update :send_update_sms

  private

  def send_create_sms
    body = "New encounter for patient #{patient.try(:full_name)} was created"
    TextMessage.create(to: provider.try(:primary_phone), body: body)
  end

  def send_update_sms
    body = "Encounter for patient #{patient.try(:full_name)} was updated"
    TextMessage.create(to: provider.try(:primary_phone), body: body)
  end
end
