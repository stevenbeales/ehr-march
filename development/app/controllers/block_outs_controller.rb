class BlockOutsController < ApplicationController
  def create
    authorize Appointment, :create?
    block_out = BlockOut.create(block_out_params)
    if block_out.persisted?
      flash[:notice] = 'Block Out created successfully'
      remote_redirect_to(providers_path)
    else
      flash[:error] = block_out.errors.full_messages.to_sentence
      redirect_to new_appointment_path
    end
  end

  private

  def block_out_params
    params.require(:block_out).permit(
      :patient_id,
      :time_for,
      :block_datetime_date,
      :block_datetime_time,
      :duration,
      :description,
      :note,
      :recurring,
      :recur_every,
      :range_day
    )
  end
end
