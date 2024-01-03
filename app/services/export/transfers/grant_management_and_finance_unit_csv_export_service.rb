class Export::Transfers::GrantManagementAndFinanceUnitCsvExportService
  require "csv"

  COLUMN_HEADERS = %i[
    academy_name
    academy_urn
    outgoing_trust_name
    outgoing_trust_ukprn
    incoming_trust_name
    incoming_trust_ukprn
    inadequate_ofsted
    two_requires_improvement
    financial_safeguarding_governance_issues
    outgoing_trust_to_close
    advisory_board_date
    transfer_date
    added_by_email
    assigned_to_email
    link_to_project
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
