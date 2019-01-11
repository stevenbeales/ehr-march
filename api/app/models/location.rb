class Location
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :location_name,    type: String
  field :location_phone,   type: String
  field :location_fax,     type: String
  field :location_address, type: String
  field :city,             type: String
  field :state,            type: String
  field :zip,              type: Integer
  field :location_npi,     type: String
  field :location_tin_en,  type: String
  field :colour,           type: String

  belongs_to :provider
  has_many   :providers, foreign_key: :practice_location_id
  has_many   :timeslots, dependent: :destroy

  before_validation :generate_colour, on: [:create]
  before_validation :phony_normalize

  def time_ranges_with_days
    schedule = []
    closed = timeslots.where(specific_hour: Timeslot.specific_hours.first(2).last).map{ |slot| slot.weekday_letter }
    opened = timeslots.where(specific_hour: Timeslot.specific_hours.last).map{ |slot| slot.weekday_letter }
    specific_timeslots = timeslots.where(specific_hour: Timeslot.specific_hours.first).map{ |slot| { day: slot.weekday_letter, from: slot.from.try(:strftime, '%I:%M %p'), to: slot.to.try(:strftime, '%I:%M %p') } }
    if specific_timeslots.any?
      grouped_specific_timeslots = specific_timeslots.group_by{ |slot| slot[:from] }.map { |from, days| { from: from, to: days.group_by{ |slot| slot[:to] } } }
      grouped_specific_timeslots.each do |range|
        range[:to].each do |to_time, days_range|
          schedule << days_range.map { |day| day[:day] }.join(' ') + ", #{range[:from]} - #{to_time}"
        end
      end
    end
    schedule << closed.join(' ') + ', Closed/NA' if closed.present?
    schedule << opened.join(' ') + ', Open 24 Hrs' if opened.present?
    schedule
  end

  def amount_of_practice_user
    providers.count
  end

  private

  def phony_normalize
    self.location_phone = PhonyRails.normalize_number(location_phone,  default_country_code: 'US')
    self.location_fax   = PhonyRails.normalize_number(location_fax,  default_country_code: 'US')
  end

  def generate_colour
    Activation.colour
  end
end
