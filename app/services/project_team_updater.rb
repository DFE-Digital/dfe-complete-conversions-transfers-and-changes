class ProjectTeamUpdater
  class ProjectTeamError < StandardError; end

  def initialize(project:)
    @project = project
  end

  def update!
    ActiveRecord::Base.transaction do
      if @project.assigned_to_regional_caseworker_team
        @project.update!(team: Project.teams["regional_casework_services"])
      else
        raise ProjectTeamError.new("Project region is nil, project_id: #{@project.id}") if Project.teams[@project.region].nil?

        @project.update!(team: Project.teams[@project.region])
      end
    rescue ActiveRecord::RecordInvalid
      raise ProjectTeamError.new("Project team update failed, project_id: #{@project.id}")
    end
  end
end
