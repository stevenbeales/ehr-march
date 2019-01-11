class AttachInvitationPdf < Prawn::Document

  def initialize(name, birth, code)
    super()
    text_box "#{name}",  at: [10, 700], size: 12
    text_box "#{birth}", at: [10, 650], size: 12
    text_box "#{code}",  at: [10, 600], size: 12
  end
end
