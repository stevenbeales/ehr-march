class CalendarsController < ApplicationController
  before_filter :check_role,    except: [:open_reschedule, :reschedule, :move]
  before_filter :load_calendar, only:   [:edit, :update, :destroy, :move, :resize]
  before_filter :determine_calendar_type, only: :create

  layout 'provider'

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    if @calendar.save
      redirect_to :back
    else
      render text: @calendar.errors.full_messages.to_sentence, status: 422
    end
  end

  def show
    redirect_to appointment_path(Calendar.find(params[:id]).appointment)
  end

  def open_reschedule
    authorize Appointment, :reschedule?
    @calendar = Calendar.find(params[:id])
    @start_time = @calendar.start_time + params[:days].to_i.days
    @days = params[:days]
  end

  def reschedule
    authorize Appointment, :reschedule?
    appointment = Calendar.find(params[:id]).appointment
    appointment.update(appointment_datetime: appointment.appointment_datetime + params[:days].to_i.days)
    if params[:reschedule]
      body = "Your appointment rescheduled from #{params[:old_show_start_time]} to #{params[:new_show_start_time]}"
      TextMessage.create(patient_id: appointment.patient_id, provider_id: current_user.provider.id, to: appointment.patient.user.email, from: current_user.email, body: body)
      EmailMessage.create(to: appointment.patient.user, from: current_user, body: body, draft: false)
    end
    redirect_to :back
  end

  def new_appointment
    redirect_to new_appointment_path
  end

  def schedule
    @providers  = current_user.provider.all_providers
    appointments = current_user.provider.appointments
    @calendars = prepare_calendars(appointments.map(&:calendar))
    @settings  = prepare_settings
  end

  def get_calendars
    @calendars = Calendar.where(and: [{:start_time.ge => Time.at(params['start'].to_i).to_formatted_s(:db)},
                                      {:end_time.le   => Time.at(params['end'].to_i).to_formatted_s(:db)}])
    render json: prepare_calendars(@calendars).to_json
  end

  def prepare_calendars(calendars)
    calendars.map do |calendar|
      {
          id: calendar.id,
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
          room: calendar.appointment.room.try(:room),
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
      @calendar.all_day   = params[:all_day]
      @calendar.save
    end
    render nothing: true
  end

  def resize
    if @calendar
      @calendar.end_time = make_time_from_minute_and_day_delta(@calendar.end_time)
      @calendar.save
    end
    render nothing: true
  end

  def edit
    render json: { form: render_to_string(partial: 'edit_form') }
  end

  # def update
  #   case params[:calendar][:commit_button]
  #     when 'Update All Occurrence'
  #       @calendars = @calendar.calendar_serial.calendars
  #       @calendar.update(@calendars, calendar_params)
  #     when 'Update All Following Occurrence'
  #       @calendars = @calendar.calendar_serial.calendars.where(:start_time.gt => @calendar.start_time.to_formatted_s(:db)).reject{ |c| c.id == @calendar.id }.to_a
  #       @calendar.update(@calendars, calendar_params)
  #     else
  #       @calendar.attributes = calendar_params
  #       @calendar.save
  #   end
  #   render nothing: true
  # end

  def destroy
    case params[:delete_all]
      when 'true'
        @calendar.calendar_serial.destroy
      when 'future'
        @calendars = @calendar.calendar_serial.calendars.where(:start_time.gt => @calendar.start_time.to_formatted_s(:db)).reject{ |c| c.id == @calendar.id }.to_a
        @calendar.calendar_serial.calendars.delete(@calendars)
      else
        @calendar.destroy
    end
    render nothing: true
  end

  def filter
    appointments = current_user.provider.appointments.where(and:
                                     [{:provider_id.in           => params[:provider_ids]},
                                     {:location.in               => params[:locations]},
                                     {:room_id.in                => params[:room_ids]},
                                     {:appointment_status_id.in  => params[:status_ids]},
                                     {:appointment_type_id.in    => params[:type_ids]}])
    if appointments.any?
      render json: prepare_calendars(appointments.map(&:calendar)).to_json.html_safe
    else
      render plain: ''
    end
  end

  def targets
    if option = set_target
      render partial: "calendars/#{option}_filter_li", locals: { provider: Provider.find(params[:id]) }
    else
      render nothing: true
    end
  end

  private

  def load_calendar
    @calendar = Calendar.find(params[:id])
    unless @calendar
      render json: { message: "Calendar Not Found.."}, status: 404 and return
    end
  end

  def calendar_params
    params.require(:calendar).permit(
        :title,
        :description,
        :start_time,
        :end_time,
        :all_day)
  end

  def determine_calendar_type
    if params[:period] == "Does not repeat"
      @calendar = Calendar.new(calendar_params)
    else
      @calendar = CalendarSerial.new(calendar_params)
      @calendar.period    = params[:period]
      @calendar.frequency = params[:frequency]
    end
  end

  def make_time_from_minute_and_day_delta(calendar_time)
    params[:minute_delta].to_i.minutes.from_now((params[:day_delta].to_i).days.from_now(calendar_time))
  end

  def set_target
    %(location room appointment_status appointment_type).include?(params[:target]) ? params[:target] : nil
  end

  def check_role
    authorize :calendar, :show?
  end
end
