class SessionsController < Devise::SessionsController
  before_filter :disable_emergency_access, only: [:destroy]

  protected

  def disable_emergency_access
    current_user.provider.update(emergency_access: false) if current_user.role == :Provider
  end
end