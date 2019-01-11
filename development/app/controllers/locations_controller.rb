class LocationsController < ApplicationController
  before_filter :check_role

  def form
    authorize :setting, :show?
    @location = params[:id].present? ? Location.find(params[:id]) : Location.new
  end

  def create
    authorize :setting, :show?
    flash[:error] = nil
    params[:location][:zip] = params[:location][:zip].to_i
    location = Location.create(location_params.merge({provider_id: current_user.provider.main_provider_id}))
    params[:location][:timeslots].each do |_, timeslot_params|
      timeslot_params.parse_time_select! :from
      timeslot_params.parse_time_select! :to
      timeslot = Timeslot.create(timeslot_params(timeslot_params).merge({ location_id: location.id }))
      flash[:error] = timeslot.errors.full_messages.to_sentence if timeslot.errors.present?
    end
    if location.errors.present? || flash[:error].present?
      flash[:error] = "#{location.errors.full_messages.to_sentence} #{flash[:error]}"
      redirect_to form_locations_path
    else
      current_user.provider.update(practice_location_id: location.id)
      flash[:notice] = 'Location created successfully'
      remote_redirect_to settings_practice_path
    end
  end

  def update
    authorize :setting, :show?
    flash[:error] = nil
    params[:location][:timeslots].each do |_, p|
      p.parse_time_select! :from
      p.parse_time_select! :to
      timeslot = Timeslot.find(p[:id])
      flash[:error] = timeslot.errors.full_messages.to_sentence unless timeslot.update(timeslot_params(p))
    end
    unless flash[:error].present?
      flash[:notice] = 'Location updated successfully'
    end
    redirect_to settings_schedule_path
  end

  def primary_location
    authorize :setting, :show?
    provider = params[:provider_id].present? ? Provider.find(params[:provider_id]) : current_user.provider
    if params[:checked] == 'true'
      provider.update(practice_location_id: params[:id])
    else
      provider.update(practice_location_id: nil)
    end
    render nothing: true
  end

  private

  def location_params
    params.require(:location).permit(
      :provider_id,
      :location_name,
      :location_phone,
      :location_fax,
      :location_address,
      :city,
      :state,
      :zip,
      :location_npi,
      :location_tin_en
    )
  end

  def timeslot_params(parameters)
    parameters.permit(
        :location_id,
        :weekday,
        :from,
        :to,
        :specific_hour
    )
  end

  def check_role
    redirect_to '/404' if current_user.blank? || current_user.role != :Provider
  end
end