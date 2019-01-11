class ErrorsController < BaseController

  def show
    render json: { code: status_code }, status: status_code
  end

  protected

  def status_code
    params[:data][:code] || 500
  end
end