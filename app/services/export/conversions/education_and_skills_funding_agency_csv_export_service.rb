class Export::Conversions::EducationAndSkillsFundingAgencyCsvExportService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    school_urn
    school_name
    academy_urn
    academy_name
    reception_to_six_years
    seven_to_eleven_years
    twelve_or_above_years
    incoming_trust_identifier
    incoming_trust_companies_house_number
    incoming_trust_name
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
  ]

  def initialize(projects)
    @projects = projects
  end
end
