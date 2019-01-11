class PracticesController < BaseController
  before_filter :check_role

  def create
    code = Activation.code
    user = User.create(user_params.merge({password: code, password_confirmation: code, confirmed_at: Time.now, role: :Provider}))
    practice = Provider.create(practice_params.merge({user_id: user.id, provider_id: current_user.provider.id }))
    if user.persisted? || practice.persisted?
      practice.update(user_id: user.id)
      InvitationMailer.send_practice_invitation(user.email, user.provider.full_name).deliver
      render json: JSONAPI::Serializer.serialize(practice), status: 200
    else
      render json: { data: { errors: user.errors.full_messages + practice.errors.full_messages } }, status: 422
    end
  end

  def edit
    render json: JSONAPI::Serializer.serialize(Provider.find(params[:data][:id])), status: 200
  end

  def update
    user = User.find(params[:data][:user][:user_id])
    practice = user.provider
    if user.update(user_params) && practice.update(practice_params)
      render json: JSONAPI::Serializer.serialize(practice), status: 200
    else
      render json: { data: { errors: user.errors.full_messages + practice.errors.full_messages } }, status: 422
    end
  end

  private

  def user_params
    params.require(:data).require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :confirmed_at,
        :role
    )
  end

  def practice_params
    params.require(:data).require(:practice).permit(
      :practice_role,
      :provider_id,
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

  def check_role
    authorize Provider, :admin?
  end
end
