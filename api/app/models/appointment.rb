class Appointment
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.durations
    [
        :'15 min',
        :'30 min',
        :'45 min',
        :'1 hour',
        :'1 hour 15 min',
        :'1 hour 30 min',
        :'1 hour 45 min',
        :'2 hours',
        :'2 hours 15 min',
        :'2 hours 30 min',
        :'2 hours 45 min',
        :'3 hours'
    ]
  end

  def self.statuses
    [
        :'Confirmed',
        :'Not Confirmed',
        :'Cancelled',
        :'Rescheduled'
    ]
  end

  field  :location,             type: String
  field  :reason,               type: Text
  field  :appointment_datetime, type: Time
  field  :duration,             type: Enum,     in: self.durations,      default: self.durations.first
  field  :contact_email,        type: String
  field  :contact_phone,        type: String
  field  :reminder,             type: Boolean
  field  :colour,               type: String

  has_one    :calendar,                dependent: :destroy
  belongs_to :room
  belongs_to :appointment_type
  belongs_to :appointment_status
  has_many   :referrals,               dependent: :destroy
  belongs_to :patient
  belongs_to :provider
  has_one    :to_do,                   dependent: :destroy

  attr_accessor :appointment_datetime_date, :appointment_datetime_time

  before_validation :phony_normalize
  before_validation :generate_colour, on: [:create, :update]
  before_validation :update_calendar, on: [:update]
  before_validation :set_datetimes

  after_create :create_calendar
  after_create :create_to_do
  after_initialize :get_datetimes

  def duration_in_minutes
    step = 15 # minutes
    duration_index = Appointment.durations.find_index(duration) + 1
    step * duration_index * 60
  end

  def to_s
    "#{appointment_datetime.to_time.strftime("%d/%m/%Y %I:%M %p")}"
  end

  private

  def phony_normalize
    self.contact_phone = PhonyRails.normalize_number(contact_phone, default_country_code: 'US')
  end

  def generate_colour
    self.colour = Activation.colour
  end

  def create_calendar
    Calendar.create(calendar_params.merge({appointment: self}))
  end

  def update_calendar
    calendar.update(calendar_params) if calendar.present?
  end

  def calendar_params
    {
        title: appointment_type.try(:appt_type),
        description: reason.present? ? reason : 'appointment detail',
        start_time: appointment_datetime.to_time,
        end_time: appointment_datetime.to_time + duration_in_minutes,
        all_day: false
    }
  end

  def get_datetimes
    self.appointment_datetime ||= Time.now

    self.appointment_datetime_date ||= self.appointment_datetime.to_date.to_s(:db)
    self.appointment_datetime_time ||= "#{'%02d' % self.appointment_datetime.to_time.hour}:#{'%02d' % self.appointment_datetime.to_time.min}"
  end

  def set_datetimes
    self.appointment_datetime = "#{self.appointment_datetime_date} #{self.appointment_datetime_time}".to_time
  end

  def create_to_do
    ToDo.create(appointment_id: id, done: false)
  end
end
