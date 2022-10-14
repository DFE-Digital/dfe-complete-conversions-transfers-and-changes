# Standard GOV.UK date format, use via `Date.tomorrow.to_formatted_s(:govuk)`
# https://design-system.service.gov.uk/components/date-input/
Date::DATE_FORMATS[:govuk] = "%-d %B %Y"
Date::DATE_FORMATS[:govuk_weekday] = "%-d %B %Y, %a"
Date::DATE_FORMATS[:govuk_month] = "%B %Y"
Date::DATE_FORMATS[:govuk_month_only] = "%B"
Time::DATE_FORMATS[:govuk_date_time] = "%-d %B %Y %H:%M"
Time::DATE_FORMATS[:govuk_date_time_date_only] = "%-d %B %Y"
