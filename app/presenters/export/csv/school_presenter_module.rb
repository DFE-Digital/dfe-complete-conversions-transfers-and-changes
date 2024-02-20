module Export::Csv::SchoolPresenterModule
  def school_urn
    @project.urn.to_s
  end

  alias_method :school_urn_with_academy_label, :school_urn

  def school_name
    return unless @project.establishment.present?

    @project.establishment.name
  end

  def school_type
    return unless @project.establishment.present?

    @project.establishment.type
  end

  alias_method :school_type_with_academy_label, :school_type

  def school_phase
    return unless @project.establishment.present?

    @project.establishment.phase
  end

  def school_dfe_number
    return unless @project.establishment.present?

    @project.establishment.dfe_number
  end

  def school_address_1
    return unless @project.establishment.present?

    @project.establishment.address_street
  end

  def school_address_2
    return unless @project.establishment.present?

    @project.establishment.address_locality
  end

  def school_address_3
    return unless @project.establishment.present?

    @project.establishment.address_additional
  end

  def school_address_town
    return unless @project.establishment.present?

    @project.establishment.address_town
  end

  def school_address_county
    return unless @project.establishment.present?

    @project.establishment.address_county
  end

  def school_address_postcode
    return unless @project.establishment.present?

    @project.establishment.address_postcode
  end

  def school_age_range
    return unless @project.establishment.present?

    "#{@project.establishment.age_range_lower} - #{@project.establishment.age_range_upper}"
  end

  def school_sharepoint_folder
    return unless @project.establishment_sharepoint_link.present?

    @project.establishment_sharepoint_link
  end

  alias_method :school_sharepoint_link_with_academy_label, :school_sharepoint_folder
end
