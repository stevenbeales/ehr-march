class SettingsController < ApplicationController
  layout 'providers_settings'
  before_filter :check_role

  def practice
    authorize :setting, :show?
    @locations = current_user.provider.all_practice_locations
    @practices = current_user.provider.providers if policy(:practice).show?
  end

  def access_permissions
    authorize Provider, :admin?
    @permissions = current_user.provider.all_permissions
  end

  def update_permissions
    authorize Provider, :admin?
    current_user.provider.permissions.each do |permission|
      permission.availabilities.each do |availability|
        availability.update(available: params[:provider][:permissions][permission.id][:availabilities][availability.id][:available])
      end
    end
    flash[:notice] = 'Permissions updated successfully'
    redirect_to :back
  end

  def set_admin
    authorize :practice, :update?
    Provider.find(params[:id]).update(admin: params[:admin])
    render nothing: true
  end

  def schedule
    authorize :setting, :schedule?
    @practices = current_user.provider.providers
  end

  def update_schedule
    authorize :setting, :schedule?
    params[:provider][:schedule_general].parse_time_select! :calendar_from
    params[:provider][:schedule_general].parse_time_select! :calendar_to
    schedule = current_user.provider.schedule_general
    if schedule.update(schedule_params)
      flash[:notice] = 'Schedule updated successfully'
    else
      flash[:error] = schedule.errors.full_messages.to_sentence
    end
    redirect_to settings_schedule_path
  end

  def add_user_added_practice
    authorize :practice, :create?
    if params[:redirect_main]
      remote_redirect_to settings_practice_path
    else
      @practice = User.find(params[:id]).provider
      @code = params[:code]
    end
  end

  def set_practice_location_color
    authorize :setting, :show?
    Location.find(params[:id]).update(colour: params[:colour])
    render nothing: true
  end

  def get_schedule_fields
    authorize :setting, :schedule?
    case params[:type]
    when 'room'
      render json: current_user.provider.rooms.to_json
    when 'status'
      render json: current_user.provider.appointment_statuses.to_json
    when 'type'
      render json: current_user.provider.appointment_types.to_json
    end
  end

  def update_schedule_fields
    authorize :setting, :schedule?
    case params[:type]
    when 'room'
      current_user.provider.rooms.find(params[:id]).update(room: params[:name])
    when 'type'
      current_user.provider.appointment_types.find(params[:id]).update(appt_type: params[:name])
    when 'status'
      current_user.provider.appointment_statuses.find(params[:id]).update(name: params[:name])
    end
    render nothing: true
  end

  def update_schedule_color_fields
    authorize :setting, :schedule?
    case params[:type]
    when 'type'
      current_user.provider.appointment_types.find(params[:id]).update(colour: params[:colour])
    when 'status'
      current_user.provider.appointment_statuses.find(params[:id]).update(colour: params[:colour])
    end
    render nothing: true
  end

  def add_schedule_fields
    authorize :setting, :schedule?
    case params[:type]
    when 'room'
      room = Room.create(provider_id: current_user.provider.id, room: '')
      render json: { id: room.id }
    when 'type'
      type = AppointmentType.create(provider_id: current_user.provider.id, appt_type: '')
      render json: { id: type.id, colour: type.colour }
    when 'status'
      status = AppointmentStatus.create(provider_id: current_user.provider.id, name: '')
      render json: { id: status.id, colour: status.colour }
    end
  end

  def destroy_schedule_fields
    authorize :setting, :schedule?
    case params[:type]
    when 'room'
      current_user.provider.rooms.find(params[:id]).destroy
    when 'type'
      current_user.provider.appointment_types.find(params[:id]).destroy
    when 'status'
      current_user.provider.appointment_statuses.find(params[:id]).destroy
    end
    render nothing: true
  end


  private

  def schedule_params
    params.require(:provider).require(:schedule_general).permit(
      :slot_size,
      :past_apps,
      :calendar_from,
      :calendar_to,
      :color_code,
      :outside_practice_hour,
      :multiple_apps,
      :reschedule_for_patient,
      :reschedule_time
    )
  end

  def room_params(parameters)
    parameters.permit(
      :room,
      :_destroy
    )
  end

  def appointment_type_params
    params.require(:provider).require(:schedule_general).permit(
      :id,
      :appt_type,
      :colour,
      :_destroy
    )
  end

  def appointment_status_params
    params.require(:provider).require(:schedule_general).permit(
      :id,
      :name,
      :colour,
      :_destroy
    )
  end

  def check_role
    redirect_to '/404' if current_user.blank? || current_user.role != :Provider
  end
end
