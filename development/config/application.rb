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

module Html
  class Application < Rails::Application

    config.generators do |g|
      #g.test_framework :minitest, spec: true, fixture: true
      g.helper false
      g.view_specs false
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # config.to_prepare do
    #   Devise::Mailer.layout 'mailer'
    # end

    config.autoload_paths << "#{Rails.root}/app/reports"
    config.autoload_paths << Rails.root.join('lib')

    config.time_zone = 'Eastern Time (US & Canada)'
    config.exceptions_app = self.routes
    # config.active_record.raise_in_transactional_callbacks = true

  end
end
