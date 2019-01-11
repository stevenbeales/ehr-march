class PatientAppointment
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.appointment_types
    [
        :'Consultation',
        :'Crown/Bridge Delivery',
        :'Crown/Bridge Prep',
        :'Emergency',
        :'Endo',
        :'New Patient',
        :'New Patient – Child',
        :'Oral Surgery',
        :'Prophy Appointment',
        :'Prophy-Child',
        :'Prophy/Regular Appointment',
        :'Regular Appointment'
    ]
  end

  field  :date,             type: Time
  field  :location,         type: String
  field  :appointment_type, type: Enum, in: self.appointment_types, default: self.appointment_types.first
  field  :note,             type: Text
  field  :phone,            type: String
  field  :email,            type: String

  belongs_to :provider
  belongs_to :patient

  before_validation :phony_normalize
  after_create :create_sms

  private

  def phony_normalize
    self.phone = PhonyRails.normalize_number(phone,  default_country_code: 'US')
  end

  def create_sms
    body = "New appointment #{appointment_type.try(:appt_type)} created on #{date.try(:strftime, '%Y-%m-%d %H:%m')} #{note}"
    TextMessage.create(to: provider.try(:primary_phone), body: body)
  end
end
