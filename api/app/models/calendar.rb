class Calendar
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field  :title,       type: String
  field  :start_time,  type: Time
  field  :end_time,    type: Time
  field  :all_day,     type: Boolean
  field  :description, type: Text

  belongs_to :calendar_serial
  belongs_to :appointment

  REPEATS = {
      no_repeat: "Does not repeat",
      days:      "Daily",
      weeks:     "Weekly",
      months:    "Monthly",
      years:     "Yearly"
  }

  def validate_timings
    if (start_time >= end_time) and !all_day
      errors[:base] << "Start Time must be less than End Time"
    end
  end

  def update_calendars(calendars, calendar)
    calendars.each do |c|
      begin
        old_start_time, old_end_time = c.start_time, c.end_time
        c.attributes = calendar
        if calendar_serial.period.downcase == 'monthly' or calendar_serial.period.downcase == 'yearly'
          new_start_time = make_date_time(c.start_time, old_start_time)
          new_end_time   = make_date_time(c.start_time, old_end_time, c.end_time)
        else
          new_start_time = make_date_time(c.start_time, old_end_time)
          new_end_time   = make_date_time(c.end_time, old_end_time)
        end
      rescue
        new_start_time = new_end_time = nil
      end
      if new_start_time and new_end_time
        c.start_time, c.end_time = new_start_time, new_end_time
        c.save
      end
    end

    calendar_serial.attributes = calendar
    calendar_serial.save
  end

  private

  def make_date_time(original_time, difference_time, event_time = nil)
    DateTime.parse("#{original_time.hour}:#{original_time.min}:#{original_time.sec}, #{event_time.try(:day) || difference_time.day}-#{difference_time.month}-#{difference_time.year}")
  end
end
