class Export::Transfers::GrantManagementAndFinanceUnitCsvExportService < Export::CsvExportService
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
    academy_surplus_deficit
    trust_surplus_deficit
    advisory_board_date
    provisional_date
    transfer_date
    added_by_email
    assigned_to_email
    link_to_project
  ]

  def initialize(projects)
    @projects = projects
  end
end
