class AdminController < ApplicationController
  before_filter :check_role

  layout 'admin', only: [:index]

  def index; end

  protected

  def check_role
    authorize :admin, :admin?
  end
end
