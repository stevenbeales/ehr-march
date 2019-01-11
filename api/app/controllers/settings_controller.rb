class SettingsController < BaseController
  def practice
    authorize :setting, :show?
    locations = current_user.provider.all_practice_locations
    practices = current_user.provider.providers
    render json: { data: { locations: locations, practices: practices } }, status: 200
  end

  def access_permissions
    authorize Provider, :admin?
    permissions = current_user.provider.all_permissions
    render json: JSONAPI::Serializer.serialize(permissions, is_collection: true)
  end

  def update_permissions
    puts "#"*100
    puts params
    authorize Provider, :admin?
    current_user.provider.permissions.each do |permission|
      permission.availabilities.each do |availability|
        availability.update(available: params[:data][:provider][:permissions][permission.id][:availabilities][availability.id][:available])
      end
    end
    render json: {}, status: 200
  end

  def set_admin
    authorize :practice, :update?
    Provider.find(params[:data][:id]).update(admin: params[:data][:admin])
    render json: {}, status: 200
  end

  def schedule
    authorize :setting, :schedule?
    practices = current_user.provider.providers
    render json: JSONAPI::Serializer.serialize(practices, is_collection: true)
  end

  def update_schedule
    authorize :setting, :schedule?
    errors = []

    general = current_user.provider.schedule_general
    errors = general.errors.full_messages if general.update(schedule_general_params)

    params[:data][:rooms_attributes].each do |room_attr|
      if room_attr[:room_id].present?
        room = Room.find(room_attr[:room_id])
        room_attr[:_destroy] == 'true' ? room.destroy : room.update(room: room_attr[:room])
        errors << room.errors.full_messages
      end
    end

    params[:data][:appointment_types_attributes].each do |type_attr|
      if type_attr[:appointment_type_id].present?
        type = AppointmentType.find(type_attr[:appointment_type_id])
        type_attr[:_destroy] == 'true' ? type.destroy : type.update(appt_type: type_attr[:appt_type], colour: type_attr[:colour])
        errors << type.errors.full_messages
      end
    end

    params[:data][:appointment_statuses_attributes].each do |status_attr|
      if status_attr[:appointment_status_id].present?
        status = AppointmentStatus.find(status_attr[:appointment_status_id])
        status_attr[:_destroy] == 'true' ? status.destroy : status.update(name: status_attr[:name], colour: status_attr[:colour])
        errors << status.errors.full_messages
      end
    end

    errors.flatten!
    if errors.blank?
      render json: {}, status: 200
    else
      render json: { errors: errors }, status: 422
    end
  end

  def add_user_added_practice
    authorize :practice, :create?
    practice = User.find(params[:data][:id]).provider
    render json: JSONAPI::Serializer.serialize(practice), status: 200
  end

  def set_practice_location_color
    authorize :setting, :show?
    Location.find(params[:data][:id]).update(colour: params[:data][:colour])
    render json: {}, status: 200
  end

  private

  def schedule_general_params
    params.require(:data).require(:schedule_general_attributes).permit(
      :id,
      :slot_size,
      :past_apps,
      :calendar_from,
      :calendar_to,
      :outside_practice_hour,
      :multiple_apps,
      :reschedule_for_patient,
      :reschedule_time
    )
  end
end
