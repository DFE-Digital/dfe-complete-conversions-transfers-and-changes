class OpeningProjectsCsvExporter
  require "csv"

  def initialize(projects)
    @projects = projects

    raise ArgumentError.new("You must provide at least one project") if @projects.count.zero?
  end

  def call
    @csv = CSV.generate(headers: true) do |csv|
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
      mp_name: mp_details.name,
      mp_email: mp_details.email,
      mp_address_line_1: mp_details.address.line1,
      mp_address_line_2: mp_details.address.line2,
      mp_address_line_3: mp_details.address.line3,
      mp_address_postcode: mp_details.address.postcode
    }
  end

  private def fetch_mp_details(project)
    Api::MembersApi::Client.new.member_for_constituency(project.establishment.parliamentary_constituency)
  end
end
