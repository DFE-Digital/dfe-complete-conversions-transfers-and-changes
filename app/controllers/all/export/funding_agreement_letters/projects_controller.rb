class All::Export::FundingAgreementLetters::ProjectsController < ApplicationController
  def csv
    authorize Project, :index?

    projects = ProjectsForExportService.new.funding_agreement_letters_projects(month: month, year: year)
    csv = Export::FundingAgreementLettersCsvExporterService.new(projects).call

    send_data csv, filename: "opening_#{month}_#{year}.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
