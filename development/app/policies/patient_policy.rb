class PatientPolicy < BasePolicy
  def create?
    available?
  end

  def update?
    available?
  end

  def patient?
    current_user.patient?
  end
end
