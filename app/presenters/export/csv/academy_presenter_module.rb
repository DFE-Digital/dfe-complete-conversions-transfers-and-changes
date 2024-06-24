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
    if @project.academy_urn.nil? || @academy.name.nil?
      return I18n.t("export.csv.project.values.unconfirmed")
    end

    @academy.name
  end

  def academy_type
    return unless @academy.present?

    @academy.type
  end

  def academy_dfe_number
    return unless @academy.present?

    @academy.dfe_number
  end

  def academy_address_1
    return unless @academy.present?

    @academy.address_street
  end

  def academy_address_2
    return unless @academy.present?

    @academy.address_locality
  end

  def academy_address_3
    return unless @academy.present?

    @academy.address_additional
  end

  def academy_address_town
    return unless @academy.present?

    @academy.address_town
  end

  def academy_address_county
    return unless @academy.present?

    @academy.address_county
  end

  def academy_address_postcode
    return unless @academy.present?

    @academy.address_postcode
  end

  def academy_contact_name
    contacts = @contacts_fetcher.all_project_contacts_grouped
    return if contacts["school_or_academy"].blank?

    contacts["school_or_academy"].pluck(:name).join(",")
  end

  def academy_contact_email
    contacts = @contacts_fetcher.all_project_contacts_grouped
    return if contacts["school_or_academy"].blank?

    contacts["school_or_academy"].pluck(:email).join(",")
  end
end
