class PatientAppointmentsController < ApplicationController

  def create
    authorize Patient, patient?
    patient_appointment = PatientAppointment.create(patients_appointment_params)
    if patient_appointment.persisted?
      flash[:notice] = 'Appointment created successfully'
      remote_redirect_to patients_path
    else
      flash[:error] = patient_appointment.errors.full_messages.to_sentence
      redirect_to new_appointment_patients_path
    end
  end

  private

  def patients_appointment_params
    params.require(:patient_appointment).permit(
      :provider_id,
      :patient_id,
      :date,
      :location,
      :appointment_type,
      :note,
      :phone,
      :email
    )
  end
end
