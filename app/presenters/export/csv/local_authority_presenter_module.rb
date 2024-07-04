module Export::Csv::LocalAuthorityPresenterModule
  def local_authority_code
    return unless @local_authority.present?

    @local_authority.code.to_s
  end

  def local_authority_name
    return unless @local_authority.present?

    @local_authority.name
  end

  def local_authority_contact_name
    local_authority_contact&.name
  end

  def local_authority_contact_email
    local_authority_contact&.email
  end

  def local_authority_address_1
    return unless @local_authority.present?

    @local_authority.address_1
  end

  def local_authority_address_2
    return unless @local_authority.present?

    @local_authority.address_2
  end

  def local_authority_address_3
    return unless @local_authority.present?

    @local_authority.address_3
  end

  def local_authority_address_town
    return unless @local_authority.present?

    @local_authority.address_town
  end

  def local_authority_address_county
    return unless @local_authority.present?

    @local_authority.address_county
  end

  def local_authority_address_postcode
    return unless @local_authority.present?

    @local_authority.address_postcode
  end

  private def local_authority_contact
    @contacts_fetcher.local_authority_contact
  end
end
