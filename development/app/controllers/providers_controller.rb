class ProvidersController < ApplicationController
  before_filter :check_role
  before_action :set_provider, only: [:show, :edit, :destroy]
  before_action :check_lock, except: [:index, :unlock]
  before_action :find_message, only: [:open_message, :reply_message, :destroy_message,
                                      :prev_message, :next_message]
  skip_before_filter :verify_authenticity_token, only: [:save_message]

  layout 'provider'

  before_filter :prepare_params, only: [:update]

  def index
    authorize Provider, :provider?
    @appointments = current_user.provider.appointments.page(params[:page]).per(10)
    @messages = current_user.inbox
    @to_dos   = @appointments.map(&:to_do)
  end

  def show
    authorize Provider, :provider?
    @provider = current_user.providers.find(params[:id])
  end

  def new
    authorize Provider, :provider?
    @provider = current_user.provider.new
  end

  def add_patient
    authorize Patient, :create?
    @user = User.new
  end

  def download_pdf
    authorize Patient, :create?
    pdf = InvitationPdf.new(params[:name], params[:birth], params[:code])
    send_data pdf.render,
              filename: 'PatientPortal-Invitation.pdf',
              type: 'application/pdf'
  end

  def send_invite_email
    authorize Patient, :create?
    InvitationMailer.send_invitation(params[:name], params[:last_name], params[:birth], params[:code], params[:email]).deliver
    render nothing: true
  end

  def add_patient_from_appointment
    authorize Patient, :create?
    @user = User.new
  end

  def show_myaccount
    authorize Provider, :provider?
  end

  def request_emergency_access
    authorize Provider, :provider?
  end

  def update_emergency_access
    authorize Provider, :provider?
    provider = current_user.provider
    if provider.update(emergency_access_reason: params[:provider][:emergency_access_reason], emergency_access: true)
      flash[:notice] = 'Emergency access was sent successfully'
    else
      flash[:error] = provider.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  def set_emergency_access
    params[:emergency_access] ? authorize(Provider, :admin?) : authorize(Provider, :provider?)
    Provider.find(params[:id]).update(emergency_access: params[:emergency_access])
    redirect_to :back
  end

  def set_status
    authorize Provider, :admin?
    Provider.find(params[:id]).update(status: params[:status])
    redirect_to :back
  end

  def invite_to_portal
    authorize Patient, :create?
    @patient = Patient.find(params[:patient_id])
  end

  def save_message
    authorize EmailMessage, :show?
    message = EmailMessage.create(message_params.merge({to_id: params[:email_message][:to_id], from_id: current_user.id}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:commit] == 'Send'
      flash[:notice] = 'Message saved successfully'
      remote_redirect_to providers_path
    else
      flash[:error] = message.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def destroy_message
    authorize EmailMessage, :show?
    @message.destroy
    remote_redirect_to providers_path
  end

  def prev_message
    authorize EmailMessage, :show?
    old_message = @message
    @message = current_user.inbox.where(:created_at.lt => @message.created_at).order_by(:created_at).last
    @message = current_user.inbox.last if @message == nil || old_message == @message
    render partial: 'message_open_form'
  end

  def next_message
    authorize EmailMessage, :show?
    old_message = @message
    @message = current_user.inbox.where(:created_at.gt => @message.created_at).order_by(:created_at).first
    @message = current_user.inbox.first if @message == nil || old_message == @message
    render partial: 'message_open_form'
  end

  def first_message
    authorize EmailMessage, :show?
    @message = current_user.provider.email_messages.order_by(:created_at).first
    case params[:type]
      when 'open'
        render partial: 'message_open_form'
      when 'reply'
        render partial: 'message_reply_form'
      else
        render nothing: true
    end
  end

  def edit
    authorize Provider, :provider?
    @provider = current_user.provider.find(params[:id])
  end

  def create
    authorize Provider, :provider?
    @provider = current_user.provider.build(provider_params)
    @provider.user_id = current_user.id

    respond_to do |format|
      if @provider.save
        format.html { redirect_to providers_path, notice: 'Patient was successfully created.' }
        format.json { render :show, status: :created, location: @provider }
      else
        format.html { render :new }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize Provider, :provider?
    user = current_user
    if user.update(user_params)
      provider = current_user.provider
      if provider.update(provider_params)
        flash[:notice] = 'Your profile updated successfully'
      else
        flash[:error] = provider.errors.full_messages.to_sentence
      end
    else
      flash[:error] = user.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  def destroy
    authorize Provider, :provider?
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_url, notice: 'Provider was successfully destroyed' }
      format.json { head :no_content }
    end
  end

  def lock
    authorize Provider, :provider?
    current_user.update(locked: true)
    render nothing: true
  end

  def unlock
    authorize Provider, :provider?
    if current_user.valid_password? params[:password]
      current_user.update(locked: false)
      render json: { status: 'Ok' }
    else
      render json: { status: 'Fail', error: 'Wrong password' }
    end
  end

  private

  def set_provider
    @provider = Provider.find(params[:id])
    unless @provider = current_user.provider.where(id: params[:id]).first
      flash[:alert] = 'Provider not found.'
      redirect_to root_url
    end
  end

  def check_lock
    redirect_to providers_path if current_user.locked
  end

  def find_message
    @message = EmailMessage.find(params[:message_id])
  end

  def prepare_params
    params[:provider][:expiration_date] = params[:provider][:expiration_date].to_time
  end

  def user_params
    params.require(:provider).require(:user).permit(
      :email
    )
  end

  def provider_params
    params.require(:provider).permit(
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
      :status,
      :accepting_patient,
      :enable_online_booking,
      :biography,
      :primary_phone,
      :mobile_phone,
      :alt_email,
      :username,
      :profile_image
      )
  end

  def message_params
    params.require(:email_message).permit(
        :subject_id,
        :body,
        :urgent,
        :attachment,
        :remote_attachment_url,
    )
  end

  def check_role
    redirect_to '/404' if current_user.blank? || current_user.role != :Provider
  end
end
