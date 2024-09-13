module Export::Csv::IncomingTrustPresenterModule
  def incoming_trust_identifier
    return unless @project.incoming_trust.present?

    @project.incoming_trust.group_identifier.to_s
  end

  def incoming_trust_ukprn
    return unless @project.incoming_trust_ukprn.present?

    @project.incoming_trust_ukprn.to_s
  end

  def incoming_trust_companies_house_number
    return unless @project.incoming_trust.present?

    @project.incoming_trust.companies_house_number.to_s
  end

  def incoming_trust_name
    return unless @project.incoming_trust.present?

    @project.incoming_trust.name
  end

  def incoming_trust_address_1
    return unless @project.incoming_trust.present?

    @project.incoming_trust.address_street
  end

  def incoming_trust_address_2
    return unless @project.incoming_trust.present?

    @project.incoming_trust.address_locality
  end

  def incoming_trust_address_3
    return unless @project.incoming_trust.present?

    @project.incoming_trust.address_additional
  end

  def incoming_trust_address_town
    return unless @project.incoming_trust.present?

    @project.incoming_trust.address_town
  end

  def incoming_trust_address_county
    return unless @project.incoming_trust.present?

    @project.incoming_trust.address_county
  end

  def incoming_trust_address_postcode
    return unless @project.incoming_trust.present?

    @project.incoming_trust.address_postcode
  end

  def incoming_trust_main_contact_name
    @project.incoming_trust_main_contact&.name
  end

  def incoming_trust_main_contact_role
    @project.incoming_trust_main_contact&.title
  end

  def incoming_trust_main_contact_email
    @project.incoming_trust_main_contact&.email
  end

  def incoming_trust_ceo_contact_name
    return unless @project.key_contacts&.incoming_trust_ceo.present?

    @project.key_contacts.incoming_trust_ceo.name
  end

  def incoming_trust_ceo_contact_role
    return unless @project.key_contacts&.incoming_trust_ceo.present?

    @project.key_contacts.incoming_trust_ceo.title
  end

  def incoming_trust_ceo_contact_email
    return unless @project.key_contacts&.incoming_trust_ceo.present?

    @project.key_contacts.incoming_trust_ceo.email
  end

  def incoming_trust_sharepoint_link
    return unless @project.incoming_trust_sharepoint_link.present?

    @project.incoming_trust_sharepoint_link
  end
end
