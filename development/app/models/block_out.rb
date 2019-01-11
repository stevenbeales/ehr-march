class BlockOut
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.time_fors
    [
        :'Individual Providers',
        :'Staff',
        :'Practice Location'
    ]
  end

  def self.range_days
    [
        :'M',
        :'T',
        :'W',
        :'Th',
        :'F',
        :'Sa',
        :'Su',
    ]
  end


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

  field :time_for,       type: Enum,         in: self.time_fors,      default: self.time_fors.first
  field :block_datetime, type: Time
  field :duration,       type: Enum,         in: self.durations,      default: self.durations.first
  field :description,    type: Text
  field :note,           type: Text
  field :recurring,      type: Boolean
  field :recur_every,    type: String
  field :range_day,      type: Enum,         in: self.range_days,     default: self.range_days.first

  belongs_to :patient

  after_initialize :get_datetimes
  before_validation :set_datetimes

  attr_accessor :block_datetime_date, :block_datetime_time

  def get_datetimes
    self.block_datetime ||= Time.now

    self.block_datetime_date ||= self.block_datetime.to_date.to_s(:db)
    self.block_datetime_time ||= "#{'%02d' % self.block_datetime.hour}:#{'%02d' % self.block_datetime.min}"
  end

  def set_datetimes
    self.block_datetime = "#{self.block_datetime_date} #{self.block_datetime_time}".to_time
  end
end
