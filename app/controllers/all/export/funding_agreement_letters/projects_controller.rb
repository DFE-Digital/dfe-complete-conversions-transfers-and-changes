class All::Export::FundingAgreementLetters::ProjectsController < ApplicationController
  def csv
    authorize Project, :index?

    projects = ConversionProjectsFetcherService.new.sorted_openers(month, year)
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
