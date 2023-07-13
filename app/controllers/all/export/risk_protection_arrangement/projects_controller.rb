class All::Export::RiskProtectionArrangement::ProjectsController < ApplicationController
  def index
    @months = export_months
  end

  def csv
    authorize Project, :index?

    projects = ProjectsForExportService.new.risk_protection_arrangement_projects(month: month, year: year)
    csv = Export::RiskProtectionArrangementCsvExportService.new(projects).call

    send_data csv, filename: "#{year}-#{month}_risk_protection_arrangement_export.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end

  private def export_months
    6.times.map do |index|
      Date.today.last_month.at_beginning_of_month + index.months
    end
  end
end
