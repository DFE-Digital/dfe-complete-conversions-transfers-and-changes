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
end
