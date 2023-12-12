class Export::Transfers::AcademiesDueToTransferCsvExportService
  require "csv"

  COLUMN_HEADERS = %i[
    school_name
    school_urn
    local_authority_name
    outgoing_trust_name
    outgoing_trust_companies_house_number
    outgoing_trust_ukprn
    incoming_trust_name
    incoming_trust_companies_house_number
    incoming_trust_ukprn
    two_requires_improvement
    inadequate_ofsted
    financial_safeguarding_governance_issues
    outgoing_trust_to_close
    request_new_urn_and_record
    bank_details_changing
    region
    assigned_to_email
    transfer_date
    all_conditions_met
  ]

  def initialize(projects)
    @projects = projects
  end

  def call
    @csv = CSV.generate("\uFEFF", headers: true, encoding: "UTF-8") do |csv|
      csv << headers
      if @projects.any?
        @projects.each do |project|
          csv << row(project)
        end
      end
    end
  end

  private def headers
    COLUMN_HEADERS.map do |column|
      I18n.t("export.csv.project.headers.#{column}")
    end
  end

  private def row(project)
    presenter = Export::Csv::ProjectPresenter.new(project)

    COLUMN_HEADERS.map do |column|
      presenter.public_send(column)
    end
  end
end
