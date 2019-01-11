AnyLogin.setup do |config|
  config.provider = :devise
  config.enabled = Rails.env.to_s == 'development'
  config.collection_method = :all
  config.redirect_path_after_login = :new_user_session_path
  config.login_on = :both
  config.limit = :none
end
