require 'capybara/rspec'
require 'capybara/rails'

Capybara.configure do |config|
  config.javascript_driver = :chrome
  config.default_max_wait_time = 15
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
