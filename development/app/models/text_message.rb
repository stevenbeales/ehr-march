class TextMessage
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field  :to,              type: String
  field  :from,            type: String
  field  :body,            type: Text

  belongs_to :provider
  belongs_to :patient

  before_create :send_message, if: Proc.new { Rails.env == 'production' }

  def send_message
    from = "+#{Rails.application.secrets.twilio_phone_number}"
    client = Twilio::REST::Client.new
    client.messages.create(
      from: from,
      to:   to,
      body: body
    )
  end
end
