class TextMessagesController < BaseController

  def create
    text_message = TextMessage.create(message_attributes)
    if text_message.persisted?
      render json: JSONAPI::Serializer.serialize(text_message), status: 200
    else
      render json: text_message.errors.full_messages, status: 422
    end
  end

  private

  def message_attributes
    {
        to: params[:data][:To],
        from: params[:data][:From],
        body: params[:data][:Body].try(:strip).try(:downcase)
    }
  end
end
