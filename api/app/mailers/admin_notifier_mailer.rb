class AdminNotifierMailer < ActionMailer::Base
  def notify(body)
    @body = body
    mail(
      from:     Rails.application.secrets.admin_email,
      to:       Rails.application.secrets.admin_email,
      subject:  Rails.application.secrets.admin_email_subject
    )
  end
end
