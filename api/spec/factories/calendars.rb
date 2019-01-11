# == Schema Information
#
# Table name: calendars
#
#  id                 :integer          not null, primary key
#  calendar_serial_id :integer
#  appointment_id     :integer
#  title              :string(255)
#  start_time         :datetime
#  end_time           :datetime
#  all_day            :boolean          default(FALSE)
#  description        :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_calendars_on_calendar_serial_id  (calendar_serial_id)
#

FactoryGirl.define do
  factory :calendar do

  end

end
