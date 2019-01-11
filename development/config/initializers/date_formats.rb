Date::DATE_FORMATS[:month_and_year] = '%B %Y'
Date::DATE_FORMATS[:short_ordinal]  = ->(date) { date.strftime("%B #{date.day.ordinalize}") }
Date::DATE_FORMATS[:usa_date]       = "%m-%d-%Y"
Date::DATE_FORMATS[:custom]         = "%Y-%m-%d"
Date::DATE_FORMATS[:dosespot]       = '%m/%d/%Y'
