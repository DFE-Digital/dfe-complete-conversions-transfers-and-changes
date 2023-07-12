class All::Export::RiskProtectionArrangement::ProjectsController < ApplicationController
  def csv
    authorize Project, :index?

    projects = ConversionProjectsFetcherService.new.sorted_openers(month, year)
    csv = Export::RiskProtectionArrangementCsvExportService.new(projects).call

    send_data csv, filename: "risk_protection_arrangement_export_#{month}_#{year}.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
