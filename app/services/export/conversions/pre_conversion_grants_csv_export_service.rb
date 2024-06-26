class Export::Conversions::PreConversionGrantsCsvExportService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    school_urn
    school_name
    school_type
    school_phase
    local_authority_name
    region
    conversion_type
    incoming_trust_name
    incoming_trust_identifier
    advisory_board_date
    provisional_conversion_date
    conversion_date
    date_academy_opened
    academy_order_type
    completed_grant_payment_certificate_received
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
