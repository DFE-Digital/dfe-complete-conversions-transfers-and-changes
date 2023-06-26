class OpeningProjectsCsvExporter
  require "csv"

  def initialize(projects)
    @projects = projects

    raise ArgumentError.new("You must provide at least one project") if @projects.count.zero?
  end

  def call
    @csv = CSV.generate("\uFEFF", headers: true, encoding: "UTF-8") do |csv|
      csv << headers
      @projects.each do |project|
        csv << row(project).values
      end
    end
  end

  private def headers
    example_row = row(@projects.first)
    example_row.keys.map do |column|
      I18n.t("opening_projects_csv_export.headers.#{column}")
    end
  end

  private def row(project)
    mp_details = fetch_mp_details(project)
    {
      school_urn: project.urn,
      dfe_number: project.establishment.dfe_number,
      project_type: "Conversion",
      route: I18n.t("project.openers.route.#{project.route}"),
      conversion_date: project.conversion_date.to_formatted_s(:csv),
      director_of_child_services_name: project.director_of_child_services&.name,
      director_of_child_services_role: project.director_of_child_services&.title,
      director_of_child_services_email: project.director_of_child_services&.email,
      director_of_child_services_phone: project.director_of_child_services&.phone,
      school_name: project.establishment.name,
      school_type: project.establishment.type,
      school_address_1: project.establishment.address_street,
      school_address_2: project.establishment.address_locality,
      school_address_3: project.establishment.address_additional,
      school_town: project.establishment.address_town,
      school_county: project.establishment.address_county,
      school_postcode: project.establishment.address_postcode,
      local_authority: project.establishment.local_authority&.name,
      local_authority_address_1: project.establishment.local_authority&.address_1,
      local_authority_address_2: project.establishment.local_authority&.address_2,
      local_authority_address_3: project.establishment.local_authority&.address_3,
      local_authority_address_town: project.establishment.local_authority&.address_town,
      local_authority_address_county: project.establishment.local_authority&.address_county,
      local_authority_address_postcode: project.establishment.local_authority&.address_postcode,
      trust_name: project.incoming_trust.name,
      trust_address_1: project.incoming_trust.address_street,
      trust_address_2: project.incoming_trust.address_locality,
      trust_address_3: project.incoming_trust.address_additional,
      trust_address_town: project.incoming_trust.address_town,
      trust_address_county: project.incoming_trust.address_county,
      trust_address_postcode: project.incoming_trust.address_postcode,
      mp_name: mp_details.name,
      mp_email: mp_details.email,
      mp_address_line_1: mp_details.address.line1,
      mp_address_line_2: mp_details.address.line2,
      mp_address_line_3: mp_details.address.line3,
      mp_address_postcode: mp_details.address.postcode,
      approval_date: project.advisory_board_date.to_formatted_s(:csv),
      project_lead: project.assigned_to.full_name,
      academy_name: project.academy&.name
    }
  end

  private def fetch_mp_details(project)
    Api::MembersApi::Client.new.member_for_constituency(project.establishment.parliamentary_constituency)
  end
end
