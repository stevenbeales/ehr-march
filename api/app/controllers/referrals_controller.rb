class ReferralsController < BaseController
  before_filter :check_role

  def new
    render json: JSONAPI::Serializer.serialize(Referral.new), status: 200
  end

  def create
    referral = Referral.create(referral_params)
    if referral.persisted?
      render json: JSONAPI::Serializer.serialize(referral), status: 200
    else
      render json: { errors: referral.errors.full_messages }, status: 422
    end
  end

  private

  def referral_params
    params.require(:data).require(:referral).permit(
        :provider_id,
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

  def check_role
    authorize Appointment, :create?
  end
end