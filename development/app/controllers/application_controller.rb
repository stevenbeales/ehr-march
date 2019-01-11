class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: Proc.new { redirect_to '/404' }

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout 'authorization'

  protected

  def after_sign_in_path_for(resource)
    case current_user.role
      when :Provider
        providers_path
      when :Patient
        patients_path
      when :Admin
        admin_index_path
      when :Representative
        patients_path
      else
        dashboard_index_path
    end
  end

  def remote_redirect_to(path)
    render js: "window.location='#{path}'"
  end
end
