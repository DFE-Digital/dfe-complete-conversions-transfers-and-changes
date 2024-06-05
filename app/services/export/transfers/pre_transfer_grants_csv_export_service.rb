class Export::Transfers::PreTransferGrantsCsvExportService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    academy_name
    academy_urn
    transfer_type
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
    transfer_grant_level
    advisory_board_date
    provisional_transfer_date
    transfer_date
    date_academy_transferred
    declaration_of_expenditure_certificate_date_received
    added_by_email
    assigned_to_email
    link_to_project
  ]

  def initialize(projects)
    @projects = projects
  end
end
