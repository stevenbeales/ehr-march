class CalendarSerial
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field  :description, type: Text
  field  :title,       type: String
  field  :frequency,   type: Integer
  field  :period,      type: String
  field  :start_time,  type: Time
  field  :end_time,    type: Time
  field  :all_day,     type: Boolean

  has_many :calendars, dependent: :destroy

  after_create :create_calendars_until_end_time

  def create_calendars_until_end_time(end_time=RECURRING_CALENDARS_UPTO)
    old_start_time   = start_time
    old_end_time     = end_time
    frequency_period = recurring_period(period)
    new_start_time, new_end_time = old_start_time, old_end_time

    while frequency.send(frequency_period).from_now(old_start_time) <= end_time
      self.calendars << Calendar.create(
          :title => title,
          :description => description,
          :all_day => all_day,
          :start_time => new_start_time,
          :end_time => new_end_time
      )
      new_start_time = old_start_time = frequency.send(frequency_period).from_now(old_start_time)
      new_end_time   = old_end_time   = frequency.send(frequency_period).from_now(old_end_time)

      if period.downcase == 'monthly' or period.downcase == 'yearly'
        begin
          new_start_time = make_date_time(start_time, old_start_time)
          new_end_time   = make_date_time(end_time, old_end_time)
        rescue
          new_start_time = new_end_time = nil
        end
      end
    end
  end

  def recurring_period(period)
    Calendar::REPEATS.key(period.titleize).to_s.downcase
  end

  private

  def make_date_time(original_time, difference_time)
    DateTime.parse("#{original_time.hour}:#{original_time.min}:#{original_time.sec}, #{original_time.day}-#{difference_time.month}-#{difference_time.year}")
  end
end
