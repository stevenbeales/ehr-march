class BaseController < JSONAPI::ResourceController
  include Authenticable
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: Proc.new { redirect_to '/404' }

  before_action :authenticate_with_token!
end
