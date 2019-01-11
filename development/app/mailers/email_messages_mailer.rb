class EmailMessagesMailer < ApplicationMailer
  def send_message(message)
    message.update(draft: false)
    @body = message.body
    # attachments['Attachment'] = message.attachment.read if message.attachment.present?
    mail(from:    message.from.email,
         to:      message.to.email,
         subject: message.subject.try(:name))
  end
end