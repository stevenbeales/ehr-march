class PracticesController < ApplicationController
  before_filter :check_role

  def new
    authorize :practice, :create?
  end

  def create
    authorize :practice, :create?
    code = Activation.code
    user = User.create(user_params.merge({password: code, password_confirmation: code, confirmed_at: Time.now, role: :Provider}))
    if user.persisted?
      practice = Provider.create(practice_params.merge({user_id: user.id, provider_id: current_user.provider.id }))
      if practice.persisted?
        flash[:notice] = 'User created successfully'
        redirect_to settings_add_user_added_practice_path(id: user.id, code: code)
      else
        flash[:notice] = practice.errors.full_messages.to_sentence
        remote_redirect_to settings_practice_path
      end
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      remote_redirect_to settings_practice_path
    end
  end

  def edit
    authorize :practice, :update?
    @practice = Provider.find(params[:id])
  end

  def update
    authorize :practice, :update?
    params[:user][:practice][:expiration_date] = params[:user][:practice][:expiration_date].to_time
    user = User.find(params[:user][:id])
    if user.update(user_params)
      practice = user.provider
      if practice.update(practice_params)
        flash[:notice] = 'User updated successfully'
        redirect_to settings_practice_path
      else
        flash[:error] = practice.errors.full_messages.to_sentence
        redirect_to edit_practice_path(user.practice)
      end
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to edit_practice_path(user.practice)
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :confirmed_at,
      :role
    )
  end

  def practice_params
    params.require(:user).require(:practice).permit(
      :practice_role,
      :provider_id,
      :title,
      :first_name,
      :middle_name,
      :last_name,
      :status,
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
