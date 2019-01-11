class ScheduleGeneral
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :slot_size,              type: Integer,      default: 30
  field :past_apps,              type: Boolean,      default: true
  field :calendar_from,          type: Time,         default: Time.utc(2000,1,1, 8,0,0)
  field :calendar_to,            type: Time,         default: Time.utc(2000,1,1, 17,0,0)
  field :outside_practice_hour,  type: Boolean,      default: true
  field :multiple_apps,          type: Boolean,      default: true
  field :reschedule_for_patient, type: Boolean,      default: true
  field :reschedule_time,        type: Integer,      default: 24

  belongs_to :provider

  def self.time_slot_enum
    [5, 10, 15, 30, 45, 60].map{ |time| ["#{time} Min", time] } << ["Disabled", 0]
  end

  def snap_duration
    case slot_size
      when 10..60
        "00:#{slot_size}:00"
      when 5
        "00:0#{slot_size}:00"
      else
        "00:01:00"
    end
  end
end
