class RepresentativesController < ApplicationController
  before_filter :check_role
  before_filter :find_patient
  before_filter :prepare_user_params,      only: [:create]
  before_filter :find_representative,      only: [:edit, :update, :show, :destroy, :activate, :reset_password]
  before_filter :find_all_representatives, only: [:index, :activate]

  def index
  end

  def new
    @user = User.new
    @representative = Representative.new
  end

  def create
    if params[:representative_policy]
      user = User.create(user_params)
      if user.persisted?
        representative = Representative.create(representative_params.merge({ user_id: user.id, patient_id: @patient.id }))
        if representative.persisted?
          InvitationMailer.send_representative_invitation(user.email, representative.first_name, @patient.full_name, @code).deliver_now
          flash[:notice] = 'Representative created successfully'
          redirect_to representatives_path(patient_id: @patient.id)
        else
          flash[:error] = representative.errors.full_messages.to_sentence
          redirect_to :back
        end
      else
        flash[:error] = user.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = 'You should agree with representative policy'
      redirect_to :back
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      if @representative.update(representative_params)
        flash[:notice] = 'Representative updated successfully'
        redirect_to representatives_path(patient_id: @patient.id)
      else
        flash[:error] = @representative.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def show
  end

  def destroy
    @representative.destroy
    render nothing: true
  end

  def activate
    @representatives.update_all(active: false) if @representatives.where(active: true).any?
    @representative.update(active: params[:active])
    render nothing: true
  end

  def reset_password
    code = Activation.code
    @user.update(password: code, password_confirmation: code)
    InvitationMailer.send_representative_reset_password(@user.email, @representative.first_name, @patient.full_name, code).deliver_now
  end

  protected

  def find_patient
    @patient = current_user.provider.all_patients.find(params[:patient_id])
  end

  def prepare_user_params
    @code = Activation.code
    params[:representative][:user].merge!({ password: @code,
                                            password_confirmation: @code,
                                            confirmed_at: Time.now,
                                            role: :Representative })
  end

  def find_representative
    @representative = @patient.representatives.find(params[:id])
    @user = @representative.user
  end

  def find_all_representatives
    @representatives = @patient.representatives
  end

  def user_params
    params.require(:representative).require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :role
    )
  end

  def representative_params
    params.require(:representative).permit(
        :patient_id,
        :first_name,
        :last_name,
        :primary_phone
    )
  end

  def check_role
    authorize Patient, :update?
  end
end
