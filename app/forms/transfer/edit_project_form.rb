class Transfer::EditProjectForm < EditProjectForm
  attribute :outgoing_trust_sharepoint_link, :string
  attribute :outgoing_trust_ukprn, :integer
  attribute :inadequate_ofsted, :boolean
  attribute :financial_safeguarding_governance_issues, :boolean
  attribute :outgoing_trust_to_close, :boolean

  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :outgoing_trust_ukprn, presence: true, ukprn: true
  validates :outgoing_trust_ukprn, trust_exists: true, if: -> { outgoing_trust_ukprn.present? }

  validates_with OutgoingIncomingTrustsUkprnValidator

  validates :inadequate_ofsted, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.inadequate_ofsted.inclusion")}

  validates :outgoing_trust_to_close, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.outgoing_trust_to_close.inclusion")}

  validates_with FormAMultiAcademyTrustNameValidator

  def self.new_from_project(project, user)
    new(
      project: project,
      establishment_sharepoint_link: project.establishment_sharepoint_link,
      incoming_trust_sharepoint_link: project.incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: project.outgoing_trust_sharepoint_link,
      outgoing_trust_ukprn: project.outgoing_trust_ukprn,
      incoming_trust_ukprn: project.incoming_trust_ukprn,
      new_trust_reference_number: project.new_trust_reference_number,
      new_trust_name: project.new_trust_name,
      group_id: project.group&.group_identifier,
      advisory_board_date: project.advisory_board_date,
      advisory_board_conditions: project.advisory_board_conditions,
      two_requires_improvement: project.two_requires_improvement,
      inadequate_ofsted: project.tasks_data.inadequate_ofsted,
      financial_safeguarding_governance_issues: project.tasks_data.financial_safeguarding_governance_issues,
      outgoing_trust_to_close: project.tasks_data.outgoing_trust_to_close,
      assigned_to_regional_caseworker_team: project.team.eql?("regional_casework_services"),
      handover_note_body: project.handover_note&.body,
      user: user
    )
  end

  def update(params)
    if GovukDateFieldParameters.new(:advisory_board_date, params).invalid?
      errors.add(:advisory_board_date, :invalid)
      return false
    end

    assign_attributes(params)

    return false unless valid?

    team = assigned_to_regional_caseworker_team ? "regional_casework_services" : project.team

    project.assign_attributes(
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      outgoing_trust_ukprn: outgoing_trust_ukprn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      new_trust_reference_number: new_trust_reference_number,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      two_requires_improvement: two_requires_improvement,
      team: team,
      assigned_to: project.assigned_to,
      assigned_at: project.assigned_at
    )

    project.tasks_data.assign_attributes(
      inadequate_ofsted: inadequate_ofsted,
      financial_safeguarding_governance_issues: financial_safeguarding_governance_issues,
      outgoing_trust_to_close: outgoing_trust_to_close
    )

    ActiveRecord::Base.transaction do
      project.group = group_id_to_group(group_id)

      project.save!
      project.tasks_data.save!
      update_handover_note if handover_note_body.present?
      notify_team_leaders(project) if assigned_to_regional_caseworker_team && unassigned?
    end

    project
  end

  private def unassigned?
    project.assigned_to.blank?
  end
end
