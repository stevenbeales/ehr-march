class Timeslot
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.weekdays
    [:'Sunday', :'Monday', :'Tuesday', :'Wednesday', :'Thursday', :'Friday', :'Saturday']
  end

  def self.specific_hours
    [:'Specific Hours', :'Closed/NA', :'Open 24 Hrs']
  end

  field :weekday,       type: Enum, in: self.weekdays,       default: self.weekdays.first
  field :from,          type: Time
  field :to,            type: Time
  field :specific_hour, type: Enum, in: self.specific_hours, default: self.specific_hours.first

  belongs_to :location

  def weekday_letter
    if(weekday == :'Sunday' || weekday == :'Thursday' || weekday == :'Saturday')
      weekday.to_s.first(2)
    else
      weekday.to_s.first
    end
  end
end
