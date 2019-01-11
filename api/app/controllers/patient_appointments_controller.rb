class PatientAppointmentsController < BaseController
  def create
    authorize Patient, :patient?
    params[:data][:patient_appointment][:date] = params[:data][:patient_appointment][:date].to_time
    patient_appointment = PatientAppointment.create(patients_appointment_params)
    if patient_appointment.persisted?
      render json: JSONAPI::Serializer.serialize(patient_appointment), status: 200
    else
      render json: { errors: patient_appointment.errors.full_messages }, status: 422
    end
  end

  private

  def patients_appointment_params
    params.require(:data).require(:patient_appointment).permit(
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
