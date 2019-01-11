class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!

  private

  def after_confirmation_path_for(resource_name, resource)
    root_path
  end
end
