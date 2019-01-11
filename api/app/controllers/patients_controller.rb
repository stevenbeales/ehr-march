class PatientsController < BaseController
  before_filter :check_role_patient,  only: [:index, :appointments_show, :appointments_status_actions, :new_appointment,
                                             :myhealth, :myprofile, :update_myprofile]
  before_filter :check_role_provider, only: [:create, :simple_create]
  before_filter :check_role,          only: [:update, :provider_full_info, :create_emergency_contact]
  before_filter :prepare_contact_and_kin_params, only: [:update]

  def index
    message = current_user.inbox.order_by(:created_at).first
    appointments = current_user.patient.appointments.where(:appointment_datetime.ge => Time.now.beginning_of_day)
                                                    .order_by(:appointment_datetime)
    render json: { data: { appointments: appointments, notifications: { appointment: appointments.last, message: message } } }, status: 200
  end

  def create
    params[:data][:patient][:birth] = params[:data][:patient][:birth].to_time
    user = User.create(user_params.merge({role: :Patient}))
    create_user(user, params)
  end

  def simple_create
    params[:data][:patient][:birth] = params[:data][:patient][:birth].to_time
    code = Activation.code
    params[:data][:user] = { password: code,
                      password_confirmation: code,
                      confirmed_at: Time.now,
                      role: :Patient }
    params[:data][:user].merge!({email: "#{code}@mail.com"}) unless params[:data][:user][:email].present?

    params[:data][:patient].merge!({code: code})
    user = User.create(user_params)
    create_user(user, params)
  end

  def update
    params[:data][:patient][:birth] = params[:data][:patient][:birth].to_time
    user = Patient.find(params[:data][:patient][:id]).user
    if user.update(user_params)
      patient = user.patient
      if patient.update(patient_params)
        emergency_contact = patient.emergency_contacts.first
        if emergency_contact.update(emergency_contact_params)
          next_kin = patient.next_kin
          if next_kin.update(next_kin_params)
            render json: JSONAPI::Serializer.serialize(patient), status: 200
          else
            render json: { errors: next_kin.errors.full_messages }, status: 422
          end
        else
          render json: { errors: emergency_contact.errors.full_messages }, status: 422
        end
      else
        render json: { errors: patient.errors.full_messages }, status: 422
      end
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def new_appointment
    providers = Provider.all
    render json: JSONAPI::Serializer.serialize(providers, is_collection: true),
           status: 200
  end

  def myhealth
    medications = Medication.where(:diagnosis_id.in => current_user.patient.diagnoses.map(&:id))
    render json: JSONAPI::Serializer.serialize(medications, is_collection: true),
           status: 200
  end

  def provider_full_info
    render json: { data: { locations: Provider.find(params[:data][:provider_id]).all_practice_locations } },
           status: 200
  end

  def create_emergency_contact
    emergency_contact = EmergencyContact.create(emergency_contact_params)
    if emergency_contact.persisted?
      render json: JSONAPI::Serializer.serialize(emergency_contact), status: 200
    else
      render json: { errors: emergency_contact.errors.full_messages }, status: 422
    end
  end

  private

  def create_user(user, params)
    if user.persisted?
      patient = Patient.create(patient_params.merge({provider_id: current_user.provider.main_provider_id, user_id: user.id, code: Activation.code}))
      if patient.persisted?
        render json: JSONAPI::Serializer.serialize(patient), status: 200
      else
        render json: { errors: patient.errors.full_messages }, status: 422
      end
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def user_params
    params.require(:data).require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :confirmed_at,
      :role
    )
  end

  def patient_params
    params.require(:data).require(:patient).permit(
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

  def prepare_contact_and_kin_params
    params[:data][:emergency_contact].to_a.each do |k, v|
      key = k.dup
      key.to_s.slice!('contact_')
      params[:data][:emergency_contact][key.to_sym] = v
    end

    params[:data][:next_kin].to_a.each do |k, v|
      key = k.dup
      key.to_s.slice!('kin_')
      params[:data][:next_kin][key.to_sym] = v
    end
  end

  def emergency_contact_params
    params.require(:data).require(:emergency_contact).permit(
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
    params.require(:data).require(:next_kin).permit(
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
    elsif current_user.role == :Patient
      authorize Patient, :patient?
    else
      redirect_to '/404'
    end
  end
end
