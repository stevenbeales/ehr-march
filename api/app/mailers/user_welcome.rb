class UserWelcome < ApplicationMailer
    def send_signup_email(user)
      @user = user
      mail(
        to:       @user.email,
        subject:  Rails.application.secrets.mail_user_welcome
      )
    end
end
