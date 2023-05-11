class ApplicationMailer < Mail::Notify::Mailer
  def url_to_project(project)
    project_url(project)
  end
end
