class All::Export::GrantManagementAndFinanceUnit::Conversions::ProjectsController < ApplicationController
  def index
    authorize Project, :index?

    @data = export_months.map do |month|
      {
        month: month,
        count: ProjectsForExportService.new.grant_management_and_finance_unit_conversion_projects(month: month.month, year: month.year).count
      }
    end
  end

  def show
    authorize Project, :show?
    @month = Date.new(year, month)
  end

  def csv
    authorize Project, :index?

    projects = ProjectsForExportService.new.grant_management_and_finance_unit_conversion_projects(month: month, year: year)
    csv = Export::Conversions::GrantManagementAndFinanceUnitCsvExportService.new(projects).call

    send_data csv, filename: "#{year}-#{month}_grant_management_and_finance_unit_conversions_export.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month].to_i
  end

  private def year
    params[:year].to_i
  end

  private def export_months
    12.times.map do |index|
      Date.today.at_beginning_of_month - index.months
    end
  end
end
