class All::Export::RiskProtectionArrangement::ProjectsController < ApplicationController
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
end
