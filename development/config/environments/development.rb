Rails.application.configure do
  config.action_controller.perform_caching = false
  config.action_controller.include_all_helpers = true
  config.active_support.deprecation = :log

  config.action_mailer.default_url_options = { :host => Rails.application.secrets.domain_name }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address:  Rails.application.secrets.localhost,
    port:     Rails.application.secrets.mailcatcher_port,
    domain:   Rails.application.secrets.domain_name_development
  }

  config.assets.digest = true
  config.assets.debug = true
  config.assets.raise_runtime_errors = true

  config.cache_classes = false
  config.consider_all_requests_local = false
  config.eager_load = false

  config.web_console.whiny_requests = false
  config.web_console.whitelisted_ips = %w( 127.0.0.1 188.163.1.30 159.224.50.252 ::1 )
  config.web_console.template_paths = 'app/views/web_console'
end
