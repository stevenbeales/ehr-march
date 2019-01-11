class InvitationMailer < ApplicationMailer
  def send_invitation(name, last_name, birth, code, email)
    @name = name
    @last_name = last_name
    @code = code
    pdf = AttachInvitationPdf.new(name, birth, code)
    attachments['Invitation.pdf'] = pdf.render
    mail(
      to:       email,
      subject:  Rails.application.secrets.mail_subject
    )
  end

  def send_practice_invitation(email, full_name)
    @full_name = full_name
    mail(
      to:       email,
      subject:  Rails.application.secrets.mail_subject
    )
  end
end
