class Export::Conversions::EducationAndSkillsFundingAgencyCsvExportService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    school_urn
    school_name
    school_type
    school_phase
    school_dfe_number
    local_authority_name
    region
    advisory_board_date
    academy_urn
    academy_ukprn
    academy_name
    academy_dfe_number
    reception_to_six_years
    seven_to_eleven_years
    twelve_or_above_years
    conversion_type
    incoming_trust_identifier
    incoming_trust_companies_house_number
    incoming_trust_name
    provisional_date
    conversion_date
    all_conditions_met
    risk_protection_arrangement
    academy_order_type
    two_requires_improvement
    sponsored_grant_type
    assigned_to_name
    assigned_to_email
    main_contact_name
    main_contact_email
    main_contact_title
    esfa_notes
  ]

  def initialize(projects)
    @projects = projects
  end
end
