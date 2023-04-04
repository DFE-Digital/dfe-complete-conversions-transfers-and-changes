class Conversion::Voluntary::CreateProjectForm < Conversion::CreateProjectForm
  attribute :assigned_to_regional_caseworker_team, :boolean

  CASEWORKER_TEAM_RESPONSES = [OpenStruct.new(id: true, name: I18n.t("yes")), OpenStruct.new(id: false, name: I18n.t("no"))]

  def assigned_to_regional_caseworker_team_responses
    CASEWORKER_TEAM_RESPONSES
  end

  def save
    assigned_to = assigned_to_regional_caseworker_team ? nil : user
    assigned_at = assigned_to_regional_caseworker_team ? nil : DateTime.now

    @project = Conversion::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      trust_sharepoint_link: trust_sharepoint_link,
      advisory_board_conditions: advisory_board_conditions,
      conversion_date: provisional_conversion_date,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id,
      task_list: Conversion::Voluntary::TaskList.new,
      assigned_to_regional_caseworker_team: assigned_to_regional_caseworker_team,
      assigned_to: assigned_to,
      assigned_at: assigned_at,
      directive_academy_order: directive_academy_order,
      sponsor_trust_required: directive_academy_order,
      region: region
    )

    return nil unless valid?

    ActiveRecord::Base.transaction do
      @project.save
      @note = Note.create(body: note_body, project: @project, user: user) if note_body
      notify_team_leaders(@project) if assigned_to_regional_caseworker_team
    end

    @project
  end
end
