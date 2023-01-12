class CaseworkerMailer < ApplicationMailer
  def caseworker_assigned_notification(caseworker, project)
    template_mail(
      "ec6823ec-0aae-439b-b2f9-c626809b7c61",
      to: caseworker.email,
      personalisation: {
        first_name: caseworker.first_name,
        project_url: url_to_project(project)
      }
    )
  end
end
