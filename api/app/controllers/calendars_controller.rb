class CalendarsController < BaseController
  before_filter :check_role,    except: [:reschedule, :move]
  before_filter :load_calendar, only: [:show, :open_reschedule, :reschedule, :edit, :update, :destroy, :move, :resize]

  def show
    render json: JSONAPI::Serializer.serialize(@calendar), status: 200
  end

  def open_reschedule
    start_time = @calendar.start_time + params[:data][:days].to_i.days
    render json: JSONAPI::Serializer.serialize(@calendar).merge({ start_time: start_time, days: params[:data][:days] })
  end

  def reschedule
    authorize Appointment, :reschedule?
    appointment = @calendar.appointment
    appointment.update(appointment_datetime: appointment.appointment_datetime.to_time + params[:data][:days].to_i.days)
    if params[:data][:reschedule]
      body = "Your appointment rescheduled from #{params[:data][:old_show_start_time]} to #{params[:data][:new_show_start_time]}"
      TextMessage.create(patient_id: appointment.patient.id, provider_id: current_user.provider.id, to: appointment.patient.user.email, from: current_user.email, body: body)
      EmailMessage.create(to_id: appointment.patient.user.id, from_id: current_user.id, body: body, draft: false)
    end
    render json: {}, status: 200
  end

  def schedule
    appointments = current_user.provider.appointments.where(:patient_id.in => current_user.provider.patients.map(&:id).to_a)
    calendars = prepare_calendars(appointments.map(&:calendar))
    settings  = prepare_settings
    render json: { data: { calendars: calendars, settings: settings } }
  end

  def get_calendars
    calendars = Calendar.where(and: [{:start_time.ge => params[:data][:start].to_time}, {:end_time.le => params[:data][:end].to_time}])
    render json: { data: { calendars: prepare_calendars(calendars) } }
  end

  def prepare_calendars(calendars)
    calendars.map do |calendar|
      {
          id: calendar.id,
          title: calendar.title,
          description: calendar.description || '',
          start: calendar.start_time.iso8601,
          end: calendar.end_time.iso8601,
          allDay: calendar.all_day,
          recurring: (calendar.calendar_serial_id) ? true : false,
          typeColor: calendar.appointment.appointment_type.try(:colour),
          statusColor: calendar.appointment.appointment_status.try(:colour),
          patientName: calendar.appointment.patient.first_name + ' ' + calendar.appointment.patient.last_name,
          patientPhone: calendar.appointment.patient.mobile_phone,
          providerName: calendar.appointment.patient.provider.first_name + ' ' + calendar.appointment.patient.provider.last_name,
          type: calendar.appointment.appointment_type.try(:appt_type),
          status: calendar.appointment.appointment_status.try(:name),
          room: calendar.appointment.room.room,
          roomId: calendar.appointment.room_id
      }
    end
  end

  def prepare_settings
    general = current_user.provider.schedule_general
    {
        minTime: general.calendar_from.strftime('%H:%M:%S'),
        maxTime: general.calendar_to.strftime('%H:%M:%S'),
        snapDuration: general.snap_duration
    }
  end

  def move
    authorize Appointment, :reschedule?
    if @calendar
      @calendar.start_time = make_time_from_minute_and_day_delta(@calendar.start_time)
      @calendar.end_time   = make_time_from_minute_and_day_delta(@calendar.end_time)
      @calendar.all_day   = params[:data][:all_day]
      @calendar.save
    end
    render json: {}, status: 200
  end

  def resize
    if @calendar
      @calendar.end_time = make_time_from_minute_and_day_delta(@calendar.end_time)
      @calendar.save
    end
    render json: {}, status: 200
  end

  def filter
    appointments = current_user.provider.appointments.where(and:
                                         [{:provider_id.in           => params[:data][:provider_ids]},
                                          {:location.in               => params[:data][:locations]},
                                          {:room_id.in                => params[:data][:room_ids]},
                                          {:appointment_status_id.in  => params[:data][:status_ids]},
                                          {:appointment_type_id.in    => params[:data][:type_ids]}])
    render json: { data: { calendars: (appointments.any? ? prepare_calendars(appointments.map(&:calendar)) : []) } }
  end

  private

  def load_calendar
    @calendar = Calendar.find(params[:data][:id])
    if @calendar.blank?
      render json: { error: "Calendar Not Found.."}, status: 404 and return
    end
  end

  def calendar_params
    params.require(:data).require(:calendar).permit(
        :title,
        :description,
        :start_time,
        :end_time,
        :all_day)
  end

  def make_time_from_minute_and_day_delta(calendar_time)
    params[:data][:minute_delta].to_i.minutes.from_now((params[:data][:day_delta].to_i).days.from_now(calendar_time))
  end

  def set_target
    %(location room appointment_status appointment_type).include?(params[:target]) ? params[:target] : nil
  end

  def check_role
    authorize :calendar, :show?
  end
end
