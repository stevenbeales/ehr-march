class AppointmentsController < ApplicationController
  def new
    authorize Appointment, :create?
    @appointment = Appointment.new
  end

  def create
    authorize Appointment
    appointment = Appointment.create(appointment_params.merge({appointment_status_id: current_user.provider.appointment_statuses.first.try(:id)}))
    Referral.find(params[:referral_id]).update(appointment_id: appointment.id) if params[:referral_id].present?
    if appointment.persisted?
      if params[:appointment][:reminder] == '1'
        body = "New appointment #{appointment.appointment_type.appt_type} created on #{appointment.appointment_datetime.strftime('%Y-%m-%d %H:%m')} #{appointment.reason}"
        EmailMessage.create(to_id: appointment.patient.user.id, from_id: current_user.id, body: body, draft: false)
        TextMessage.create(to: current_user.provider.primary_phone, body: body)
      end
      flash[:notice] = 'Appointment created successfully'
      remote_redirect_to(providers_path)
    else
      flash[:error] = appointment.errors.full_messages.to_sentence
      redirect_to new_appointment_path
    end
  end

  def update
    appointment = Appointment.find(params[:id])
    authorize appointment, :update?
    if appointment.update(appointment_params)
      flash[:notice] = 'Appointment saved successfully'
      Referral.find(params[:appointment][:referral_id]).update(referral_params) if params[:appointment][:referral_id].present?
      if current_user.role == :Provider
        remote_redirect_to(providers_path)
      end
      if current_user.patient?
        remote_redirect_to(patients_path)
      end
    else
      flash[:error] = appointment.errors.full_messages.to_sentence
      redirect_to appointment_path(appointment)
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def destroy
    appointment = Appointment.find(params[:id])
    authorize appointment, :update?
    appointment.destroy
    flash[:notice] = 'Appointment canceled'
    redirect_to :back
  end

  def patients
    authorize Appointment, :show?
    patients = if params[:part].present?
                 current_user.provider.all_patients.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}])
               else
                 current_user.provider.all_patients.limit(10)
               end.map{ |patient|
                        { full_name: patient.full_name,
                          id:        patient.id,
                          email:     patient.user.present? ? patient.user.email : '',
                          phones:    [patient.primary_phone, patient.mobile_phone]
                        }
                      }
    render json: patients.to_json
  end

  def referrals
    authorize Appointment, :create?
    referrals = if params[:part].present?
                  current_user.provider.referrals.where(or: [{normal: /^#{params[:data][:part]}/}, {last_name: /^#{params[:data][:part]}/}])
                else
                  current_user.provider.referrals.limit(10)
                end.map{ |referral| { full_name: referral.full_name, id: referral.id } }
    render json: referrals.to_json
  end

  def reschedule
    authorize Appointment, :reschedule?
    Appointment.find(params[:id]).update(appointment_status_id: current_user.provider.appointment_statuses.where(name: 'Reschedule').first.try(:id))
    render nothing: true
  end

  private

  def appointment_params
    params.require(:appointment).permit(
        :patient_id,
        :provider_id,
        :location,
        :room_id,
        :appointment_type_id,
        :reason,
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
    params.require(:appointment).require(:referral).permit(
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
