class All::Export::BySignificantDate::Transfers::AcademiesDueToTransfer::ProjectsController < ApplicationController
  def index
    authorize :export
    service = ProjectsForExportService.new
    @data = export_months.map do |month|
      {
        month: month,
        count: service.transfer_projects_by_significant_date(month: month.month, year: month.year).count
      }
    end
  end

  def show
    authorize :export
    @month = Date.parse("#{year}-#{month}-1")
  end

  def csv
    authorize :export
    authorize Project, :index?

    projects = ProjectsForExportService.new.transfer_projects_by_significant_date(month: month, year: year)
    csv = Export::Transfers::AcademiesDueToTransferCsvExportService.new(projects).call

    send_data csv, filename: "#{year}-#{month}_academies_due_to_transfer.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end

  private def export_months
    6.times.map do |index|
      Date.today.at_beginning_of_month + index.months
    end
  end
end
