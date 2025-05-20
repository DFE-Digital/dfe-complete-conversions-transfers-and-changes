class Conversion::EditProjectForm < EditProjectForm
  attribute :directive_academy_order, :boolean

  validates :directive_academy_order, inclusion: {in: [true, false]}

  def self.new_from_project(project, user)
    new(
      project: project,
      establishment_sharepoint_link: project.establishment_sharepoint_link,
      incoming_trust_sharepoint_link: project.incoming_trust_sharepoint_link,
      incoming_trust_ukprn: project.incoming_trust_ukprn,
      new_trust_reference_number: project.new_trust_reference_number,
      group_id: project.group&.group_identifier,
      advisory_board_date: project.advisory_board_date,
      advisory_board_conditions: project.advisory_board_conditions,
      directive_academy_order: project.directive_academy_order,
      two_requires_improvement: project.two_requires_improvement,
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
      incoming_trust_ukprn: incoming_trust_ukprn,
      new_trust_reference_number: new_trust_reference_number,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      directive_academy_order: directive_academy_order,
      two_requires_improvement: two_requires_improvement,
      team: team,
      assigned_to: project.assigned_to,
      assigned_at: project.assigned_at
    )

    ActiveRecord::Base.transaction do
      project.group = group_id_to_group(group_id)

      project.save
      update_handover_note if handover_note_body.present?
      notify_team_leaders(project) if assigned_to_regional_caseworker_team && unassigned?
    end

    project
  end

  private def unassigned?
    project.assigned_to.blank?
  end
end
