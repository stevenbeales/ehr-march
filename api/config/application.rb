require File.expand_path('../boot', __FILE__)

require 'rails'
# require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'rails/test_unit/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
  end
end
