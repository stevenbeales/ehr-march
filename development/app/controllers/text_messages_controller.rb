class TextMessagesController < ApplicationController
  before_filter :check_role

  def create
    TextMessage.create(message_attributes)
    head :ok
  end

  private

  def message_attributes
    {
        to: params[:To],
        from: params[:From],
        body: params[:Body].strip.downcase
    }
  end

  def check_role
    authorize Provider, :provider?
  end
end
