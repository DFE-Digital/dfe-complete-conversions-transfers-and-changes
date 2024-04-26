class All::Export::BySignificantDate::Conversions::AllData::ProjectsController < ApplicationController
  def date_range_csv
    authorize Project, :index?

    from_date = "#{params[:from_year]}-#{params[:from_month]}-1"
    to_date = "#{params[:to_year]}-#{params[:to_month]}-1"
    return redirect_if_dates_incorrect if Date.parse(to_date) < Date.parse(from_date)

    projects = ByMonthProjectFetcherService.new.conversion_projects_by_date_range(from_date, to_date)
    csv = Export::Conversions::ByMonthCsvExportService.new(projects).call

    send_data csv, filename: "#{from_date}-#{to_date}_schools_due_to_convert.csv", type: :csv, disposition: "attachment"
  end

  def single_month_csv
    authorize Project, :index?

    month = params[:month]
    year = params[:year]

    projects = ByMonthProjectFetcherService.new.conversion_projects_by_date(month, year)
    csv = Export::Conversions::ByMonthCsvExportService.new(projects).call

    send_data csv, filename: "#{month}-#{year}_schools_due_to_convert.csv", type: :csv, disposition: "attachment"
  end

  private def redirect_if_dates_incorrect
    redirect_to date_range_this_month_all_by_month_conversions_projects_path, alert: I18n.t("project.date_range.date_form.from_date_before_to_date")
  end
end
