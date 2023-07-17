class All::Export::FundingAgreementLetters::ProjectsController < ApplicationController
  def index
    authorize Project, :index?

    @months = export_months
  end

  def show
    @month = Date.parse("#{year}-#{month}-1")
  end

  def csv
    authorize Project, :index?

    projects = ProjectsForExportService.new.funding_agreement_letters_projects(month: month, year: year)
    csv = Export::FundingAgreementLettersCsvExporterService.new(projects).call

    send_data csv, filename: "#{year}-#{month}_funding_agreement_letters_export.csv", type: :csv, disposition: "attachment"
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
