class TeamLeaderMailer < ApplicationMailer
  def new_project_created(team_leader, project)
    template_mail(
      "ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353",
      to: team_leader.email,
      personalisation: {
        first_name: team_leader.first_name,
        project_url: project_information_url(project.id)
      }
    )
  end
end
