class PatientsController < ApplicationController
  layout 'patient'

  before_filter :check_role_patient,  only: [:index, :appointments_show, :appointments_status_actions, :new_appointment,
                                             :myhealth, :myprofile, :update_myprofile]
  before_filter :check_role_provider, only: [:create, :simple_create]
  before_filter :check_role,          only: [:update, :provider_full_info, :create_emergency_contact]

  before_filter :prepare_params, only: [:create, :simple_create]

  def index
    @message = current_user.inbox.order_by(:created_at).first
    @appointments = current_user.patient.appointments.where(:appointment_datetime.ge => Time.now.beginning_of_day)
                                                     .order_by(:appointment_datetime)
    @appointment = current_user.patient.appointments.order_by(:appointment_datetime).last
    @events_count = 1 + (@message.present? ? 1 : 0) + (@appointment.present? ? 1 : 0)
    render layout: "patient"
  end

  def create
    user = User.create(user_params)
    if user.persisted?
      patient = Patient.create(patient_params.merge({provider_id: current_user.provider.main_provider_id, user_id: user.id, code: Activation.code}))
      if patient.persisted?
        redirect_to invite_to_portal_providers_path(patient_id: patient.id)
      else
        flash[:error] = patient.errors.full_messages.to_sentence
        redirect_to add_patient_providers_path
      end
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to add_patient_providers_path
    end
  end

  def simple_create
    user = User.create(user_params)
    if user.persisted?
      patient = Patient.create(patient_params.merge({provider_id: current_user.provider.main_provider_id, user_id: user.id, code: Activation.code}))
      if patient.persisted?
        redirect_to new_appointment_path
      else
        flash[:error] = patient.errors.full_messages.to_sentence
        redirect_to add_patient_from_appointment_providers_path
      end
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to add_patient_from_appointment_providers_path
    end
  end

  def update
    params[:user][:patient][:birth] = params[:user][:patient][:birth].to_time
    params[:user][:patient][:zip]   = params[:user][:patient][:zip].to_i
    user = Patient.find(params[:id]).user
    if user.update(user_params)
      patient = user.patient
      if patient.update(patient_params)
        emergency_contact = patient.emergency_contacts.first
        if emergency_contact.update(emergency_contact_params(params[:user][:patient]))
          next_kin = patient.next_kin
          if next_kin.update(next_kin_params)
            flash[:notice] = 'Patient updated successfully'
            remote_redirect_to(patient_treatments_path)
          else
            flash[:error] = next_kin.errors.full_messages.to_sentence
            redirect_to show_patient_main_patient_treatments_path(id: params[:id])
          end
        else
          flash[:error] = emergency_contact.errors.full_messages.to_sentence
          redirect_to show_patient_main_patient_treatments_path(id: params[:id])
        end
      else
        flash[:error] = patient.errors.full_messages.to_sentence
        redirect_to show_patient_main_patient_treatments_path(id: params[:id])
      end
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to show_patient_main_patient_treatments_path(id: params[:id])
    end
  end

  def appointments_show
    @appointments_upcoming = current_user.patient.appointments.where(:appointment_datetime.ge => Time.now).order_by(:appointment_datetime)
    @appointments_past = current_user.patient.appointments.where(:appointment_datetime.lt => Time.now).order_by(:appointment_datetime)
  end

  def appointments_status_actions
    if params[:status].present?
      status_id = params[:status].to_i
      Appointment.find(params[:id])
                 .update(status: status_id, appointment_status_id: status_id)     if params[:id].present?
      Appointment.where(:id.in => JSON.parse(params[:ids]))
                 .update_all(status: status_id, appointment_status_id: status_id) if params[:ids].present?
    end
    @appointments_upcoming = current_user.patient.appointments.where(:appointment_datetime.ge => Time.now).order_by(:appointment_datetime)
    render partial: 'patients/appointments_upcoming', locals: { appointments_upcoming: @appointments_upcoming }, layout: nil
  end

  def new_appointment
    @providers = Provider.all.map{ |provider| ["#{provider.title} #{provider.last_name} #{provider.first_name}", provider.id] }
  end

  def myhealth
    @medications = Medication.where(:id.in => current_user.patient.diagnoses.map(&:id))
  end

  def myprofile
  end

  def update_myprofile
    params[:user][:patient][:birth] = params[:user][:patient][:birth].to_time
    params[:user][:patient][:zip]   = params[:user][:patient][:zip].to_i
    user = Patient.find(params[:id]).user
    if user.update(user_params)
      patient = user.patient
      if patient.update(patient_params)
        flash[:notice] = 'Patient updated successfully'
      else
        flash[:error] = patient.errors.full_messages.to_sentence
      end
    else
      flash[:error] = user.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  def provider_full_info
    render json: Provider.find(params[:provider_id]).all_locations.to_json
  end

  def create_emergency_contact
    if emergency_contact = EmergencyContact.create(emergency_contact_params(params))
      flash[:notice] = 'Emergency contact successfully'
    else
      flash[:error] = emergency_contact.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  private

  def prepare_params
    params[:user][:patient][:birth] = params[:user][:patient][:birth].to_time
    params[:user].merge!({email: "#{Activation.code}@mail.com"}) unless params[:user][:email].present?
    params[:user].merge!({password: @code,
                          password_confirmation: @code,
                          confirmed_at: Time.now,
                          role: :Patient})
  end

  def user_params
    params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :confirmed_at,
        :role
    )
  end

  def patient_params
    params.require(:user).require(:patient).permit(
        :provider_id,
        :first_name,
        :last_name,
        :middle_name,
        :birth,
        :gender,
        :social_number,
        :patient_id,
        :active,
        :declined_portal_access,
        :preferred_language,
        :ethnicity,
        :american_race,
        :asian_race,
        :african_race,
        :hawaiian_race,
        :white_race,
        :undetermined_race,
        :email_reminder,
        :sms_reminder,
        :immunization_registry,
        :mobile_phone,
        :primary_phone,
        :work_phone,
        :ext,
        :street_address,
        :city,
        :state,
        :zip,
        :profile_image
    )
  end

  def emergency_contact_params(parameters)
    parameters.require(:emergency_contact).permit(
        :first_name,
        :last_name,
        :middle_name,
        :relation,
        :mobile_phone,
        :email,
        :street_address,
        :city,
        :state,
        :zip
    )
  end

  def next_kin_params
    params.require(:user).require(:patient).require(:next_kin).permit(
        :first_name,
        :last_name,
        :middle_name,
        :relation,
        :mobile_phone,
        :email,
        :street_address,
        :city,
        :state,
        :zip
    )
  end

  def check_role_patient
    authorize Patient, :patient?
  end

  def check_role_provider
    authorize Patient, :create?
  end

  def check_role
    if current_user.role == :Provider
      authorize Patient, :update?
    elsif current_user.patient?
      authorize Patient, :patient?
    else
      redirect_to '/404'
    end
  end
end
