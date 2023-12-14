class All::Export::GrantManagementAndFinanceUnit::Conversions::ProjectsController < ApplicationController
  def index
    authorize Project, :index?

    @months = export_months
  end

  def csv
    authorize Project, :index?

    projects = ProjectsForExportService.new.grant_management_and_finance_unit_projects(month: month, year: year)
    csv = Export::Conversions::GrantManagementAndFinanceUnitCsvExportService.new(projects).call

    send_data csv, filename: "#{year}-#{month}_grant_management_and_finance_unit_conversions_export.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end

  private def export_months
    12.times.map do |index|
      Date.today.at_beginning_of_month - index.months
    end
  end
end
