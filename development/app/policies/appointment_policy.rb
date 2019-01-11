class AppointmentPolicy < BasePolicy
  def create?
    available?
  end

  def update?
    if current_user.patient?
      current_user.patient.id == @record.patient_id
    else
      available?
    end
  end

  def show?
    if current_user.patient?
      current_user.patient.id == @record.patient_id
    else
      available?
    end
  end

  def reschedule?
    available?
  end
end
