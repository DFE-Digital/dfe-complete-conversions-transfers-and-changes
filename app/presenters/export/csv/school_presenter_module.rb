module Export::Csv::SchoolPresenterModule
  def school_urn
    @project.urn.to_s
  end

  alias_method :school_urn_with_academy_label, :school_urn

  def school_name
    return unless @project.establishment.present?

    @project.establishment.name
  end

  alias_method :school_name_with_academy_label, :school_name

  def school_type
    return unless @project.establishment.present?

    @project.establishment.type
  end

  alias_method :school_type_with_academy_label, :school_type

  def school_phase
    return unless @project.establishment.present?

    return school_type if @project.establishment&.phase == "Not applicable"
    @project.establishment&.phase
  end

  def school_dfe_number
    return unless @project.establishment.present?

    @project.establishment.dfe_number
  end

  def school_address_1
    return unless @project.establishment.present?

    @project.establishment.address_street
  end

  alias_method :school_address_1_with_academy_label, :school_address_1

  def school_address_2
    return unless @project.establishment.present?

    @project.establishment.address_locality
  end

  alias_method :school_address_2_with_academy_label, :school_address_2

  def school_address_3
    return unless @project.establishment.present?

    @project.establishment.address_additional
  end

  alias_method :school_address_3_with_academy_label, :school_address_3

  def school_address_town
    return unless @project.establishment.present?

    @project.establishment.address_town
  end

  alias_method :school_address_town_with_academy_label, :school_address_town

  def school_address_county
    return unless @project.establishment.present?

    @project.establishment.address_county
  end

  alias_method :school_address_county_with_academy_label, :school_address_county

  def school_address_postcode
    return unless @project.establishment.present?

    @project.establishment.address_postcode
  end

  alias_method :school_address_postcode_with_academy_label, :school_address_postcode

  def school_age_range
    return unless @project.establishment.present?

    "#{@project.establishment.age_range_lower} - #{@project.establishment.age_range_upper}"
  end

  def school_sharepoint_folder
    return unless @project.establishment_sharepoint_link.present?

    @project.establishment_sharepoint_link
  end

  alias_method :school_sharepoint_link_with_academy_label, :school_sharepoint_folder

  def school_main_contact_name
    @project.establishment_main_contact&.name
  end

  def school_main_contact_email
    @project.establishment_main_contact&.email
  end

  def school_main_contact_role
    @project.establishment_main_contact&.title
  end

  def headteacher_contact_name
    return unless @project.key_contacts&.headteacher.present?

    @project.key_contacts.headteacher.name
  end

  def headteacher_contact_role
    # when exported this is ALWAYS 'headteacher'
    return unless @project.key_contacts&.headteacher.present?

    "Headteacher"
  end

  def headteacher_contact_email
    return unless @project.key_contacts&.headteacher.present?

    @project.key_contacts.headteacher.email
  end
end
