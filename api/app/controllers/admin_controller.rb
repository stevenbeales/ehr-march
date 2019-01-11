class AdminController < BaseController
  before_filter :check_role

  def index
    render json: {}, status: 200
  end

  protected

  def check_role
    authorize :admin, :admin?
  end
end
