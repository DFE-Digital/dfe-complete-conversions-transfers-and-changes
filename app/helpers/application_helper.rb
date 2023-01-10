module ApplicationHelper
  def render_markdown(markdown, hint: false)
    additional_attributes = ["target"]
    default_attributes = Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES

    rendered_markdown = GovukMarkdown.render(markdown)
    rendered_markdown.gsub!("govuk-body-m", "govuk-hint") if hint

    sanitize(rendered_markdown, attributes: default_attributes.merge(additional_attributes))
  end

  def safe_link_to(body, url)
    allowed_attributes = %w[href target]

    link = link_to(body, url, target: :_blank)
    sanitize(link, attributes: allowed_attributes)
  end

  def support_email(name = nil, with_custom_subject = true)
    name = Rails.application.config.support_email if name.nil?
    if with_custom_subject
      subject = I18n.t("support_email_subject")
      govuk_mail_to(Rails.application.config.support_email, name, subject: subject)
    else
      govuk_mail_to(Rails.application.config.support_email, name)
    end
  end

  def path_to_project(project)
    return conversions_voluntary_project_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def path_to_project_task_list(project)
    return conversions_voluntary_project_task_list_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_task_list_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def path_to_project_notes(project)
    return conversions_voluntary_project_notes_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_notes_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def path_to_project_information(project)
    return conversions_voluntary_project_information_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_information_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def path_to_project_contacts(project)
    return conversions_voluntary_project_contacts_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_contacts_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end
end
