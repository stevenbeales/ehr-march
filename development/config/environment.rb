require File.expand_path('../application', __FILE__)

Rails.application.initialize!

Time::DATE_FORMATS[:usa_timedate] = "%d/%m/%Y %I:%M %p"
