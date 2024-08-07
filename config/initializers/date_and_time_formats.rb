# Standard GOV.UK date format, use via `Date.tomorrow.to_formatted_s(:govuk)`
# https://design-system.service.gov.uk/components/date-input/
Date::DATE_FORMATS[:govuk] = "%-d %B %Y"
Date::DATE_FORMATS[:govuk_weekday] = "%-d %B %Y, %a"
Date::DATE_FORMATS[:govuk_month] = "%B %Y"
Date::DATE_FORMATS[:govuk_short_month] = "%b %Y"
Date::DATE_FORMATS[:govuk_month_only] = "%B"

# Date format for all significant date (conversion date and transfer date)
Date::DATE_FORMATS[:significant_date] = "%b %Y"

# date format for csv files
Date::DATE_FORMATS[:csv] = "%Y-%m-%d"

# Time only
Time::DATE_FORMATS[:govuk_date_time] = "%-d %B %Y %l:%M%P"
Time::DATE_FORMATS[:govuk_date_time_date_only] = "%-d %B %Y"
