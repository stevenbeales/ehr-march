class RegistrationController < JSONAPI::ResourceController

  def create
    user = User.create(user_params.merge({role: :Provider}))
    if user.persisted?
      provider = Provider.create(provider_params.merge({user_id: user.id, practice_role: :Provider}))
      if provider.persisted?
        render json: JSONAPI::Serializer.serialize(provider), status: 200
      else
        render json: { errors: provider.errors.full_messages }, status: 422
      end
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:data).require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end

  def provider_params
    params.require(:data).require(:provider).permit(
      :title,
      :first_name,
      :middle_name,
      :last_name,
      :degree,
      :speciality,
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
      :primary_phone,
      :mobile_phone,
      :alt_email,
      :username,
      :secondary_speciality,
      :dental_licence,
      :expiration_date,
      :ein_tin,
      :npi,
      :dea,
      :upin,
      :nadean,
      :status,
      :biography,
      :accepting_patient,
      :enable_online_booking,
      :profile_image_id,
      :profile_image_filename,
      :profile_image_size,
      :profile_image_content_type
    )
  end
end
