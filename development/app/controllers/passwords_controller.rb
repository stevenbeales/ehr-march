class PasswordsController < Devise::PasswordsController

  def update
    user = User.where(reset_password_token: params[:user][:reset_password_token]).first
    if user.present? && params[:user][:captcha].to_i != user.captcha.to_i
      flash[:error] = 'Captcha is invalid'
      redirect_to :back
    else
      if params[:user][:reset_password_token] != user.reset_password_token
        flash[:error] = 'Reset password token is invalid'
        redirect_to :back
      else
        if user.update(reset_password_token: nil, reset_password_sent_at: nil, password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
          sign_in(User, user)
          redirect_to new_user_session_path
        else
          flash[:error] = user.errors.full_messages.to_sentence
          redirect_to :back
        end
      end
    end
  end

  private

  def after_resetting_password_path_for(resource)
    new_user_session_path
  end
end
