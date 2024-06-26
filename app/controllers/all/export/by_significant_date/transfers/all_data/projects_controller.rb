class All::Export::BySignificantDate::Transfers::AllData::ProjectsController < ApplicationController
  include DateRangable

  def date_range_csv
    authorize Project, :index?

    return redirect_if_dates_incorrect if @to_date < @from_date

    projects = ByMonthProjectFetcherService.new.transfer_projects_by_date_range(@from_date.to_s, @to_date.to_s)
    csv = Export::Transfers::AllDataCsvExportService.new(projects).call

    send_data csv, filename: "#{@from_date}-#{@to_date}_academies_due_to_transfer.csv", type: :csv, disposition: "attachment"
  end

  def single_month_csv
    authorize Project, :index?

    projects = ByMonthProjectFetcherService.new.transfer_projects_by_date_range(@from_date.to_s, @to_date.to_s)
    csv = Export::Transfers::AllDataCsvExportService.new(projects).call

    send_data csv, filename: "#{@from_date.month}-#{@from_date.year}_academies_due_to_transfer.csv", type: :csv, disposition: "attachment"
  end

  private def redirect_if_dates_incorrect
    redirect_to date_range_this_month_all_by_month_transfers_projects_path, alert: I18n.t("project.date_range.date_form.from_date_before_to_date")
  end
end
