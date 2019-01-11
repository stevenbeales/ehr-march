class SorterController < ApplicationController
  def appointments
    authorize Appointment, :show?
    amount = 10
    page = params[:page].present? ? params[:page].to_i : 1
    field = params[:field]
    type = params[:type].downcase.to_sym
    appointments = current_user.provider.appointments
    appointments = case field
                     when 'appointment_datetime_time'
                       appointments.order_by(appointment_datetime: type).to_a
                     when 'patient'
                       appointments.sort_by{ |appointment| appointment.patient.first_name.downcase }
                       type == :desc ? appointments.reverse : appointments
                     when 'appointment_type'
                       appointments.sort_by{ |appointment| appointment.appointment_type.appt_type }
                       type == :desc ? appointments.reverse : appointments
                     else
                       appointments.to_a
                   end.paginate(page: page, per: amount)
    render partial: 'providers/my_appointments', locals: { appointments: appointments, field: field, type: type }
  end

  def messages
    authorize EmailMessage, :show?
    field = params[:field]
    type = params[:type].downcase.to_sym
    messages = case field
                 when 'from'
                   messages = current_user.inbox.sort_by{ |message| message.from.person.first_name.downcase }
                   type == :desc ? messages.reverse : messages
                 when 'created_at'
                   current_user.inbox.order_by(created_at: type)
                 else
                   current_user.inbox
               end
    render partial: 'providers/messages', locals: { messages: messages }
  end

  def todos
    authorize ToDo, :show?
    field = params[:field]
    type = params[:type].downcase.to_sym
    to_dos = ToDo.where(:appointment_id.in => current_user.provider.appointments.map(&:id))
    to_dos = case field
               when 'patient'
                 to_dos.sort_by{ |to_do| to_do.appointment.patient.full_name.downcase }
                 type == :desc ? to_dos.reverse : to_dos
               when 'appointment_type'
                 to_dos.sort_by{ |to_do| to_do.appointment.appointment_type.appt_type }
                 type == :desc ? to_dos.reverse : to_dos
               when 'created_at'
                 to_dos.order_by(created_at: type)
             end
    render partial: 'providers/to_dos', locals: { to_dos: to_dos }
  end
end
