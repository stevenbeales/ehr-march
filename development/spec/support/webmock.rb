require 'selenium-webdriver'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include Warden::Test::Helpers

  config.before(:suite) do
    WebMock.disable_net_connect!(allow: '127.0.0.1')
  end
end