class Export::Conversions::FundingAgreementLettersCsvExporterService < Export::CsvExportService
  COLUMN_HEADERS = %i[
    school_urn
    school_name
    school_type
    school_dfe_number
    school_address_1
    school_address_2
    school_address_3
    school_address_town
    school_address_county
    school_address_postcode
    academy_urn
    academy_name
    academy_address_1
    academy_address_2
    academy_address_3
    academy_address_town
    academy_address_county
    academy_address_postcode
    incoming_trust_identifier
    incoming_trust_companies_house_number
    incoming_trust_name
    incoming_trust_address_1
    incoming_trust_address_2
    incoming_trust_address_3
    incoming_trust_address_town
    incoming_trust_address_county
    incoming_trust_address_postcode
    director_of_child_services_name
    director_of_child_services_role
    director_of_child_services_email
    local_authority_code
    local_authority_name
    local_authority_address_1
    local_authority_address_2
    local_authority_address_3
    local_authority_address_town
    local_authority_address_county
    local_authority_address_postcode
    mp_constituency
    mp_name
    mp_email
    mp_address_1
    mp_address_2
    mp_address_3
    mp_address_postcode
    advisory_board_date
    project_type
    academy_order_type
    two_requires_improvement
    sponsored_grant_type
    conversion_date
    assigned_to_name
    assigned_to_email
    main_contact_name
    main_contact_email
    main_contact_title
  ]

  def initialize(projects)
    @projects = projects
    @project_type = :conversion
  end
end
