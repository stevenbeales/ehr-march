class BasePolicy
  include AvailableChecker

  attr_reader :current_user, :record

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end
end