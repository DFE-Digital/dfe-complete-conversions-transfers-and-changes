class Contact::CreateIncomingTrustCeoContactForm < Contact::CreateProjectContactForm
  def category
    "incoming_trust"
  end

  def title
    "CEO"
  end

  def organisation_name
    @project.incoming_trust&.name
  end
end
