class BlockOutsController < BaseController

  def create
    authorize Appointment, :create?
    block_out = BlockOut.create(block_out_params)
    if block_out.persisted?
      render json: JSONAPI::Serializer.serialize(block_out), status: 200
    else
      render json: { errors: block_out.errors.full_messages }, status: 422
    end
  end

  private

  def block_out_params
    params.require(:data).require(:block_out).permit(
        :patient_id,
        :time_for,
        :duration,
        :description,
        :note,
        :recurring,
        :recur_every,
        :range_day
    )
  end
end
