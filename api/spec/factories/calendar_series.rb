# == Schema Information
#
# Table name: calendar_series
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string
#  frequency   :integer          default(1)
#  period      :string           default("monthly")
#  starttime   :datetime
#  endtime     :datetime
#  all_day     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :calendar_series do

  end

end
