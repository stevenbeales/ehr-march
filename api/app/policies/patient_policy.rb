class PatientPolicy < BasePolicy

  def create?
    available?
  end

  # from patient_treatment/profile
  def update?
    available?
  end

  def patient?
    current_user.role == :Patient
  end
end
