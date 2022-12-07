class Conversion::Involuntary::CreateProjectForm < Conversion::CreateProjectForm
  def save
    @project = Conversion::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      trust_sharepoint_link: trust_sharepoint_link,
      advisory_board_conditions: advisory_board_conditions,
      provisional_conversion_date: provisional_conversion_date,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id
    )

    if valid?
      ActiveRecord::Base.transaction do
        @project.save
        @note = Note.create(body: note_body, project: @project, user: user) if note_body
        Conversion::Involuntary::Details.create(project: @project)
        TaskListCreator.new.call(@project, workflow_root: Conversion::Involuntary::Details::WORKFLOW_PATH)
        true
      end
    end
  end
end
