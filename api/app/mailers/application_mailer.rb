class ApplicationMailer < ActionMailer::Base
  include AbstractController::Callbacks

  default from: Rails.application.secrets.default_email_reply
  layout 'mailer'

  after_filter :copy_email_to_admin

  private

  def copy_email_to_admin
    AdminNotifierMailer.notify(response_body).deliver
  end
end
