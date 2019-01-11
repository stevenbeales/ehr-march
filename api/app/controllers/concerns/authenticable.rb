module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.where(auth_token: params[:data][:auth_token]).first
  end

  def api_authorization_header(token)
    request.headers['Authorization'] =  token
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless current_user.present?
  end

  def user_signed_in?
    current_user.present?
  end
end