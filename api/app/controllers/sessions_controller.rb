class SessionsController < JSONAPI::ResourceController
  include Authenticable

  def create
    user_password = params[:data][:password]
    user_email = params[:data][:email]
    user = User.where(email: user_email).first if user_email.present?

    if user.valid_password? user_password
      user.generate_authentication_token!
      user.save
      render json: JSONAPI::Serializer.serialize(user).merge({auth_token: user.auth_token}), status: 200
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    if user = User.where(auth_token: params[:data][:auth_token]).first
      user.generate_authentication_token!
      user.save
      head 204
    else
      render json: { errors: "Not authenticated" }, status: :unauthorized
    end
  end
end
