module Export::Csv::OutgoingTrustPresenterModule
  def outgoing_trust_ukprn
    return unless @project.outgoing_trust_ukprn.present?

    @project.outgoing_trust_ukprn.to_s
  end

  def outgoing_trust_companies_house_number
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.companies_house_number.to_s
  end

  def outgoing_trust_name
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.name
  end

  def outgoing_trust_main_contact_name
    @project.outgoing_trust_main_contact&.name
  end

  def outgoing_trust_main_contact_role
    @project.outgoing_trust_main_contact&.title
  end

  def outgoing_trust_main_contact_email
    @project.outgoing_trust_main_contact&.email
  end

  def outgoing_trust_identifier
    @project.outgoing_trust.group_identifier.to_s
  end

  def outgoing_trust_address_1
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.address_street
  end

  def outgoing_trust_address_2
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.address_locality
  end

  def outgoing_trust_address_3
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.address_additional
  end

  def outgoing_trust_address_town
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.address_town
  end

  def outgoing_trust_address_county
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.address_county
  end

  def outgoing_trust_address_postcode
    return unless @project.outgoing_trust.present?

    @project.outgoing_trust.address_postcode
  end

  def outgoing_trust_sharepoint_link
    return unless @project.outgoing_trust_sharepoint_link.present?

    @project.outgoing_trust_sharepoint_link
  end

  def outgoing_trust_ceo_contact_name
    return unless @project.key_contacts&.outgoing_trust_ceo.present?

    @project.key_contacts.outgoing_trust_ceo.name
  end

  def outgoing_trust_ceo_contact_role
    return unless @project.key_contacts&.outgoing_trust_ceo.present?

    @project.key_contacts.outgoing_trust_ceo.title
  end

  def outgoing_trust_ceo_contact_email
    return unless @project.key_contacts&.outgoing_trust_ceo.present?

    @project.key_contacts.outgoing_trust_ceo.email
  end
end
