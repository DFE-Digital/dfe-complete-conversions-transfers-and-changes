class All::Export::BySignificantDate::Conversions::SchoolsDueToConvert::ProjectsController < ApplicationController
  def index
    authorize :export
    service = ProjectsForExportService.new
    @data = export_months.map do |month|
      {
        month: month,
        count: service.conversion_projects_by_significant_date(month: month.month, year: month.year).count
      }
    end
  end

  def show
    authorize :export
    @month = Date.parse("#{year}-#{month}-1")
  end

  def csv
    authorize :export

    projects = ProjectsForExportService.new.conversion_projects_by_significant_date(month: month, year: year)
    csv = Export::Conversions::SchoolsDueToConvertCsvExportService.new(projects).call

    send_data csv, filename: "#{year}-#{month}_schools_due_to_convert.csv", type: :csv, disposition: "attachment"
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
