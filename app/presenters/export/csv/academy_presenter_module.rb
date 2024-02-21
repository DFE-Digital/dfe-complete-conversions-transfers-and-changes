module Export::Csv::AcademyPresenterModule
  def academy_urn
    if @project.academy_urn.nil?
      return I18n.t("export.csv.project.values.unconfirmed")
    end

    @project.academy_urn.to_s
  end

  def academy_ukprn
    if @project.academy_urn.nil?
      return I18n.t("export.csv.project.values.unconfirmed")
    end

    @project.academy.ukprn.to_s
  end

  def academy_name
    if @project.academy_urn.nil? || @project.academy.name.nil?
      return I18n.t("export.csv.project.values.unconfirmed")
    end

    @project.academy.name
  end

  def academy_type
    return unless @project.academy.present?

    @project.academy.type
  end

  def academy_dfe_number
    return unless @project.academy.present?

    @project.academy.dfe_number
  end

  def academy_address_1
    return unless @project.academy.present?

    @project.academy.address_street
  end

  def academy_address_2
    return unless @project.academy.present?

    @project.academy.address_locality
  end

  def academy_address_3
    return unless @project.academy.present?

    @project.academy.address_additional
  end

  def academy_address_town
    return unless @project.academy.present?

    @project.academy.address_town
  end

  def academy_address_county
    return unless @project.academy.present?

    @project.academy.address_county
  end

  def academy_address_postcode
    return unless @project.academy.present?

    @project.academy.address_postcode
  end

  def academy_contact_name
    contacts = ContactsFetcherService.new.all_project_contacts(@project)
    return if contacts["school_or_academy"].blank?

    contacts["school_or_academy"].pluck(:name).join(",")
  end

  def academy_contact_email
    contacts = ContactsFetcherService.new.all_project_contacts(@project)
    return if contacts["school_or_academy"].blank?

    contacts["school_or_academy"].pluck(:email).join(",")
  end
end
