module ProvidersHelper
  def appointment_header_fields
    [
        { name: 'Time',      field: 'appointment_datetime_time' },
        { name: 'Patient',   field: 'patient' },
        { name: 'Provider',  field: 'provider' },
        { name: 'Appt Type', field: 'appointment_type' }
    ]
  end

  def my_todos_header_fields
    [
        { name: 'Type',    field: 'appointment_type' },
        { name: 'Patient', field: 'patient' },
        { name: 'Date',    field: 'created_at' }
    ]
  end
end
