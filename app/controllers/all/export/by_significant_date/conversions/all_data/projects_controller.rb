class All::Export::BySignificantDate::Conversions::AllData::ProjectsController < ApplicationController
  include DateRangable

  def date_range_csv
    authorize Project, :index?

    return redirect_if_dates_incorrect if @to_date < @from_date

    csv = create_csv

    send_data csv, filename: "#{@from_date}-#{@to_date}_schools_due_to_convert.csv", type: :csv, disposition: "attachment"
  end

  def single_month_csv
    authorize Project, :index?

    csv = create_csv

    send_data csv, filename: "#{@from_date.month}-#{@from_date.year}_schools_due_to_convert.csv", type: :csv, disposition: "attachment"
  end

  private def redirect_if_dates_incorrect
    redirect_to date_range_this_month_all_by_month_conversions_projects_path, alert: I18n.t("project.date_range.date_form.from_date_before_to_date")
  end

  private def create_csv
    projects = ByMonthProjectFetcherService.new.conversion_projects_by_date_range(@from_date, @to_date)
    Export::Conversions::AllDataCsvExportService.new(projects).call
  end
end
