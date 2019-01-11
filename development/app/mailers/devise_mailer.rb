class DeviseMailer < Devise::Mailer
  helper :application
  include AbstractController::Callbacks
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    Provider.last.update(user_id: User.last.id)
    super
  end

  after_filter :copy_email_to_admin

  private

  def copy_email_to_admin
    AdminNotifierMailer.notify(response_body).deliver
  end
end