class AdminNotifierMailer < ActionMailer::Base
  def notify(body)
    @body = body
    mail(from: Rails.application.secrets.admin_email, to: Rails.application.secrets.admin_email, subject: 'EHR notification')
  end
end