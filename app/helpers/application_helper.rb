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

  def path_to_team_lead_project_assignment(project)
    return conversions_voluntary_project_assign_team_lead_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_assign_team_lead_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def path_to_regional_delivery_officer_project_assignment(project)
    return conversions_voluntary_project_assign_regional_delivery_officer_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_assign_regional_delivery_officer_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def path_to_caseworker_project_assignment(project)
    return conversions_voluntary_project_assign_caseworker_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
    return conversions_involuntary_project_assign_caseworker_path(project) if project.task_list_type == "Conversion::Involuntary::TaskList"
  end

  def optional_cookies_set?
    cookies[:ACCEPT_OPTIONAL_COOKIES].present?
  end

  def enable_google_tag_manager?
    return false unless ENV["SENTRY_ENV"] == "production"
    return false unless ENV["GOOGLE_TAG_MANAGER_ID"].present?
    return false unless cookies[:ACCEPT_OPTIONAL_COOKIES] == "true"
    true
  end
end
