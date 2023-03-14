class AssignedToMailer < ApplicationMailer
  def assigned_notification(user, project)
    template_mail(
      "ec6823ec-0aae-439b-b2f9-c626809b7c61",
      to: user.email,
      personalisation: {
        first_name: user.first_name,
        project_url: url_to_project(project)
      }
    )
  end
end
