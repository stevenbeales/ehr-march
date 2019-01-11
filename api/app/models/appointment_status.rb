class AppointmentStatus
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.examples
    [
        :'Confirmed',
        :'Not Confirmed',
        :'Cancelled',
        :'Rescheduled',
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
        :'Regular Appointment',
        :'Reschedule'
    ]
  end

  field :name,   type: String
  field :colour, type: String

  belongs_to :provider
  has_many   :appointments

  before_validation :generate_colour, on: [:create]

  private

  def generate_colour
    self.colour = Activation.colour
  end
end
