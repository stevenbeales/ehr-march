class ProvidersController < BaseController
  before_action :check_lock, except: [:index, :unlock]
  before_action :find_message, only: [:open_message, :reply_message, :destroy_message,
                                      :prev_message, :next_message]

  before_filter :prepare_params, only: [:update]

  def index
    authorize Provider, :provider?
    appointments = current_user.provider.appointments.page(params[:page]).per(10)
    messages = current_user.inbox
    to_dos   = appointments.map(&:to_do)
    render json: { data: { appointments: appointments, messages: messages, to_dos: to_dos } },
           status: 200
  end


  def add_patient
    authorize Patient, :create?
    code = Activation.code
    user = User.new
    render json: { data: { code: code, user: user } }
  end

  def download_pdf
    authorize Patient, :create?
    pdf = InvitationPdf.new(params[:data][:name], params[:data][:birth], params[:data][:code])
    send_data pdf.render,
              filename: 'PatientPortal-Invitation.pdf',
              type: 'application/pdf'
  end

  def send_invite_email
    authorize Patient, :create?
    InvitationMailer.send_invitation(params[:data][:first_name], params[:data][:last_name], params[:data][:birth], params[:data][:code], params[:data][:email]).deliver
    render json: {}, status: 200
  end

  def save_message
    authorize EmailMessage, :show?
    message = EmailMessage.create(message_params.merge({to_id: params[:data][:email_message][:to_id], from_id: current_user.id}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:data][:commit] == 'Send'
      render json: JSONAPI::Serializer.serialize(message), status: 200
    else
      render json: { errors: message.errors.full_messages }, status: 422
    end
  end

  def prev_message
    authorize EmailMessage, :show?
    old_message = @message
    @message = current_user.inbox.where(:created_at.lt => @message.created_at).order_by(:created_at).last
    @message = current_user.inbox.last if @message == nil || old_message == @message
    render json: JSONAPI::Serializer.serialize(@message), status: 200
  end

  def next_message
    authorize EmailMessage, :show?
    old_message = @message
    @message = current_user.inbox.where(:created_at.gt => @message.created_at).order_by(:created_at).first
    @message = current_user.inbox.first if @message == nil || old_message == @message
    render json: JSONAPI::Serializer.serialize(@message), status: 200
  end

  def first_message
    authorize EmailMessage, :show?
    render json: JSONAPI::Serializer.serialize(current_user.inbox.order_by(:created_at).first), status: 200
  end

  def update
    authorize Provider, :provider?
    provider = current_user.provider
    if provider.update(provider_params)
      user = current_user
      if user.update(user_params)
        patient = current_user.provider.patients.find(params[:data][:patient][:id])
        if patient.update(patient_params)
          block_out = patient.block_outs.find(params[:data][:block_out][:id])
          if block_out.update(block_out_params)
            appointment = patient.appointments.find(params[:data][:appointment][:id])
            if appointment.update(appointment_params)
              referral = appointment.referrals.find(params[:data][:referral][:id])
              if referral.update(referral_params)
                render json: JSONAPI::Serializer.serialize(provider), status: 200
              else
                render json: { errors: referral.errors.full_messages }, status: 422
              end
            else
              render json: { errors: appointment.errors.full_messages }, status: 422
            end
          else
            render json: { errors: block_out.errors.full_messages }, status: 422
          end
        else
          render json: { errors: patient.errors.full_messages }, status: 422
        end
      else
        render json: { errors: user.errors.full_messages }, status: 422
      end
    else
      render json: { errors: provider.errors.full_messages }, status: 422
    end
  end

  def lock
    authorize Provider, :provider?
    current_user.update(locked: true)
    render json: {}, status: 200
  end

  def unlock
    authorize Provider, :provider?
    if current_user.valid_password? params[:data][:password]
      current_user.update(locked: false)
      render json: {}, status: 200
    else
      render json: { errors: ['Wrong password'] }, status: 422
    end
  end

  private

  def check_lock
    redirect_to providers_path if current_user.locked
  end

  def find_message
    @message = EmailMessage.find(params[:data][:message_id])
  end

  def prepare_params
    params[:data][:patient][:birth] = params[:data][:patient][:birth].try(:to_time)
    params[:data][:block_out][:block_datetime] = params[:data][:block_out][:block_datetime].try(:to_time)
    params[:data][:appointment][:appointment_datetime] = params[:data][:appointment][:appointment_datetime].try(:to_time)
  end

  def provider_params
    params.require(:data).require(:provider).permit(
        :title,
        :first_name,
        :middle_name,
        :last_name,
        :degree,
        :speciality,
        :secondary_speciality,
        :dental_licence,
        :street_address,
        :suit_apt_number,
        :city,
        :state,
        :zip,
        :practice_street_address,
        :practice_suit_apt_number,
        :practice_city,
        :practice_state,
        :practice_zip,
        :expiration_date,
        :ein_tin,
        :npi,
        :dea,
        :upin,
        :nadean,
        :accepting_patient,
        :enable_online_booking,
        :biography,
        :primary_phone,
        :mobile_phone,
        :alt_email,
        :username
    )
  end

  def user_params
    params.require(:data).require(:user).permit(
      :id,
      :email,
      :password,
      :password_confirmation
    )
  end

  def patient_params
    params.require(:data).require(:patient).permit(
      :id,
      :user_id,
      :provider_id,
      :first_name,
      :last_name,
      :middle_name,
      :birth,
      :gender,
      :mobile_phone,
      :primary_phone,
      :code
    )
  end

  def block_out_params
    params.require(:data).require(:block_out).permit(
      :time_for,
      :block_datetime,
      :duration,
      :description,
      :note,
      :recurring,
      :recur_every,
      :range_day
    )
  end

  def appointment_params
    params.require(:data).require(:appointment).permit(
      :id,
      :patient_id,
      :location,
      :room,
      :appointment_type,
      :reason,
      :appointment_datetime,
      :duration,
      :contact_email,
      :contact_phone,
      :reminder,
      :colour
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

  def message_params
    params.require(:data).require(:email_message).permit(
        :to_id,
        :subject_id,
        :body,
        :urgent
    )
  end
end
