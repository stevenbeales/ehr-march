class RegistrationController < Devise::RegistrationsController

  before_filter :create_provider, only: [:create]

  protected

  def create_provider
    params[:user][:provider][:zip] = params[:user][:provider][:zip].to_i
    params[:user][:provider][:practice_zip] = params[:user][:provider][:practice_zip].to_i
    provider = Provider.create(provider_params.merge({practice_role: :Provider}))
    unless provider.persisted?
      flash[:errors] = provider.errors.full_messages.to_sentence
      redirect_to :back
    end
    @provider_id = provider.id
  end

  def provider_params
    params.require(:user).require(:provider).permit(
      :title,
      :first_name,
      :middle_name,
      :last_name,
      :practice_role,
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
      :accepting_patient,
      :enable_online_booking,
      :biography,
      :profile_image,
      :remote_profile_image_url
    )
  end
end
