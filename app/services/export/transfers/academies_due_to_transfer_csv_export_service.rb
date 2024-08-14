class Export::Transfers::AcademiesDueToTransferCsvExportService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    school_name
    school_urn
    school_phase
    school_age_range
    local_authority_name
    transfer_type
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
    assigned_to_team
    provisional_transfer_date
    transfer_date
    authority_to_proceed
    main_contact_name
    main_contact_email
    main_contact_title
    headteacher_contact_name
    headteacher_contact_role
    headteacher_contact_email
  ]

  def initialize(projects)
    @projects = projects
  end
end
