class AppointmentsController < BaseController

  def new
    authorize Appointment, :create?
    render json: JSONAPI::Serializer.serialize(Appointment.new), status: 200
  end

  def create
    authorize Appointment
    params[:data][:appointment][:appointment_datetime] = params[:data][:appointment][:appointment_datetime].to_time
    appointment = Appointment.create(appointment_params.merge({appointment_status_id: current_user.provider.appointment_statuses.first.try(:id)}))
    Referral.find(params[:data][:appointment][:referral_id]).update(appointment_id: appointment.id) if params[:data][:appointment][:referral_id].present?
    if appointment.persisted?
      if params[:data][:appointment][:reminder] == true
        body = "New appointment #{appointment.appointment_type.appt_type} created on #{appointment.appointment_datetime.to_time.strftime('%Y-%m-%d %H:%m')} #{appointment.reason}"
        EmailMessage.create(to: appointment.patient.user, from: current_user, body: body, draft: false)
        TextMessage.create(patient_id: appointment.patient.try(:id), provider_id: current_user.provider.id, to: appointment.patient.try(:primary_phone), body: body)
      end
      render json: JSONAPI::Serializer.serialize(appointment), status: 200
    else
      render json: { errors: appointment.errors.full_messages }, status: 422
    end
  end

  def update
    appointment = Appointment.find(params[:id])
    authorize appointment, :update?
    if appointment.update(appointment_params)
      Referral.find(params[:data][:appointment][:referral_id]).update(referral_params) if params[:data][:appointment][:referral_id].present?
      render json: JSONAPI::Serializer.serialize(appointment), status: 200
    else
      render json: { errors: appointment.errors.full_messages }, status: 422
    end
  end

  def show
    render json: JSONAPI::Serializer.serialize(Appointment.find(params[:id]))
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    authorize @appointment, :update?
    @appointment.destroy
    render json: {}, status: 200
  end

  def patients
    authorize Appointment, :show?
    patients = if params[:data][:part].present?
      current_user.provider.all_patients.where(or: [{first_name: /^#{params[:data][:part]}/}, {last_name: /^#{params[:data][:part]}/}])
    else
      current_user.provider.all_patients.limit(10)
    end
    render json: JSONAPI::Serializer.serialize(patients, is_collection: true)
  end

  def referrals
    authorize Appointment, :create?
    referral = if params[:data][:part].present?
                 current_user.provider.referrals.where(or: [{normal: /^#{params[:data][:part]}/}, {last_name: /^#{params[:data][:part]}/}])
               else
                 current_user.provider.referrals.limit(10)
               end
    render json: JSONAPI::Serializer.serialize(referral, is_collection: true)
  end

  def reschedule
    authorize Appointment, :reschedule?
    Appointment.find(params[:data][:id])
               .update(appointment_status_id: current_user.provider.appointment_statuses.where(name: 'Reschedule').first.try(:id))
    render json: {}, status: 200
  end

  private

  def appointment_params
    params.require(:data).require(:appointment).permit(
      :patient_id,
      :provider_id,
      :location,
      :room_id,
      :appointment_type_id,
      :reason,
      :appointment_datetime,
      :appointment_datetime_date,
      :appointment_datetime_time,
      :duration,
      :contact_email,
      :contact_phone,
      :reminder,
      :colour,
      :appointment_status_id
    )
  end

  def referral_params
    params.require(:data).require(:referral).permit(
      :normal,
      :middle_name,
      :last_name,
      :individual_npi,
      :speciality,
      :phone,
      :fax,
      :email
    )
  end
end
