class Contact::CreateOutgoingTrustCeoContactForm < Contact::CreateProjectContactForm
  validate :transfer_projects_only

  def category
    "outgoing_trust"
  end

  def title
    "CEO"
  end

  def organisation_name
    @project.outgoing_trust&.name
  end

  def transfer_projects_only
    errors.add(:base, :wrong_project_type_for_category) unless @project.is_a?(Transfer::Project)
  end
end
