class ApplicationMailer < Mail::Notify::Mailer
  def url_to_project(project)
    return conversions_voluntary_project_url(project) if project.task_list.is_a?(Conversion::Voluntary::TaskList)
  end
end
