class Procedure
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.statuses
    [
        :'Other Provider',
        :'Existing',
        :'Completed',
        :'Treatment planned'
    ]
  end

  field :procedure_code,  type: String
  field :description,     type: String
  field :date_of_service, type: Time
  field :status,          type: Enum,   in: self.statuses,   default: self.statuses.first

  has_one    :surface
  has_one    :pit
  has_one    :cusp
  belongs_to :tooth_table
  belongs_to :encounter

  after_create :set_description
  after_create :send_create_sms
  after_update :send_update_sms

  def short_status
    status.present? ? status.to_s.split(' ').map{ |w| w[0] }.join().upcase : ''
  end

  private

  def set_description
    self.update(description: PROCEDURE_CODES[procedure_code.try(:to_sym)])
  end

  def send_create_sms
    body = "New procedure for patient #{encounter.try(:patient).try(:full_name)} was created"
    TextMessage.create(to: encounter.try(:provider).try(:primary_phone), body: body)
  end

  def send_update_sms
    body = "Procedure for patient #{encounter.try(:patient).try(:full_name)} was updated"
    TextMessage.create(to: encounter.try(:provider).try(:primary_phone), body: body)
  end
end
