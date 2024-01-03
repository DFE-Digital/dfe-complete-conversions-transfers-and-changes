class Export::Conversions::GrantManagementAndFinanceUnitCsvExportService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    school_urn
    school_name
    school_type
    school_phase
    local_authority_name
    region
    incoming_trust_name
    incoming_trust_identifier
    advisory_board_date
    conversion_date
    academy_order_type
    two_requires_improvement
    sponsored_grant_type
    assigned_to_name
    assigned_to_email
    link_to_project
  ]

  def initialize(projects)
    @projects = projects
  end
end
