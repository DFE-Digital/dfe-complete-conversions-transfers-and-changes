module Export::Csv::LocalAuthorityPresenterModule
  def local_authority_code
    return unless @project.local_authority.present?

    @project.local_authority.code.to_s
  end

  def local_authority_name
    return unless @project.local_authority.present?

    @project.local_authority.name
  end

  def local_authority_contact_name
    contacts = @contacts_fetcher.all_project_contacts
    return if contacts["local_authority"].blank?

    contacts["local_authority"].pluck(:name).join(",")
  end

  def local_authority_contact_email
    contacts = @contacts_fetcher.all_project_contacts
    return if contacts["local_authority"].blank?

    contacts["local_authority"].pluck(:email).join(",")
  end

  def local_authority_address_1
    return unless @project.local_authority.present?

    @project.local_authority.address_1
  end

  def local_authority_address_2
    return unless @project.local_authority.present?

    @project.local_authority.address_2
  end

  def local_authority_address_3
    return unless @project.local_authority.present?

    @project.local_authority.address_3
  end

  def local_authority_address_town
    return unless @project.local_authority.present?

    @project.local_authority.address_town
  end

  def local_authority_address_county
    return unless @project.local_authority.present?

    @project.local_authority.address_county
  end

  def local_authority_address_postcode
    return unless @project.local_authority.present?

    @project.local_authority.address_postcode
  end
end
