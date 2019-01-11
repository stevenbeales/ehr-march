FULLCALENDAR_FILE_PATH = Rails.root.join('config', 'fullcalendar.yml')
RECURRING_CALENDARS_UPTO = (Date.today.beginning_of_year + 5.years).to_time
config = File.exists?(FULLCALENDAR_FILE_PATH) ? YAML.load_file(FULLCALENDAR_FILE_PATH) || {} : {}
Calendar::Configuration = {
    'editable'    => true,
    'header'      => {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
    },
    'defaultView' => 'agendaWeek',
    'height'      => 500,
    'slotMinutes' => 15,
    'dragOpacity' => 0.5,
    'selectable'  => true,
    'timeFormat'  => "h:mm t{ - h:mm t}"
}
Calendar::Configuration.merge!(config)
Calendar::Configuration['events'] = "/calendars/get_calendars"
