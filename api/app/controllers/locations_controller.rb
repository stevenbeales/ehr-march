class LocationsController < BaseController
  before_filter :check_role

  def form
    location = params[:data][:id].present? ? Location.find(params[:data][:id]) : Location.new
    render json: JSONAPI::Serializer.serialize(location), status: 200
  end

  def create
    errors = []
    location = Location.create(location_params.merge({provider_id: current_user.provider.main_provider_id}))
    params[:data][:location][:timeslots].each do |p|
      p = prepare_param(p, location.id)
      timeslot = Timeslot.create(timeslot_params(p).merge({ location_id: location.id }))
      errors << timeslot.errors.full_messages if timeslot.errors.present?
    end
    errors << location.errors.full_messages if location.errors.present?
    errors.flatten!
    if errors.present?
      render json: { errors: errors }, status: 422
    else
      current_user.provider.update(practice_location_id: location.id)
      render json: {}, status: 200
    end
  end

  def update
    errors = []
    params[:data][:location][:timeslots].each do |p|
      if p[:id].present?
        p = prepare_param(p, p[:location_id])
        timeslot = Timeslot.find(p[:id])
        errors << timeslot.errors.full_messages unless timeslot.update(timeslot_params(p))
      end
    end
    errors.flatten!
    if errors.present?
      render json: { errors: errors }, status: 422
    else
      render json: {}, status: 200
    end
  end

  def primary_location
    provider = params[:provider_id].present? ? Provider.find(params[:provider_id]) : current_user.provider
    if params[:checked] == 'true'
      provider.update(practice_location_id: params[:id])
    else
      provider.update(practice_location_id: nil)
    end
    render json: {}, status: 200
  end

  private

  def prepare_param(p, location_id)
    p[:weekday] = p[:weekday].to_sym
    p[:specific_hour] = p[:specific_hour].to_sym
    p[:location_id] = location_id
    p[:from] = p[:from].try(:to_time)
    p[:to] = p[:to].try(:to_time)
    p
  end

  def location_params
    params.require(:data).require(:location).permit(
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

  def timeslot_params(param)
    param.permit(
        :location_id,
        :weekday,
        :from,
        :to,
        :specific_hour
    )
  end

  def check_role
    authorize :setting, :show?
  end
end
