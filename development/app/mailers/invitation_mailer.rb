class InvitationMailer < ApplicationMailer
  def send_invitation(name, last_name, birth, code, email)
    @name = name
    @last_name = last_name
    @code = code
    pdf = AttachInvitationPdf.new(name, birth, code)
    attachments['Invitation.pdf'] = pdf.render
    mail( to: email,
          subject: 'Invite you' )
  end

  def send_practice_invitation(email, full_name)
    @full_name = full_name
    mail( to: email,
          subject: 'Invite you')
  end

  def send_representative_invitation(email, first_name, patient_full_name, code)
    @first_name = first_name
    @patient_full_name = patient_full_name
    @code = code
    mail( to: email,
          subject: 'Invite you')
  end

  def send_representative_reset_password(email, first_name, patient_full_name, code)
    @first_name = first_name
    @patient_full_name = patient_full_name
    @code = code
    mail( to: email,
          subject: 'Invite you')
  end
end
