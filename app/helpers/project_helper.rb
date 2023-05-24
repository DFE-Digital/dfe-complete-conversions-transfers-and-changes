module ProjectHelper
  def age_range(establishment)
    return nil if establishment.age_range_lower.blank? || establishment.age_range_upper.blank?

    "#{establishment.age_range_lower} to #{establishment.age_range_upper}"
  end

  def display_name(user)
    return t("project_information.show.project_details.rows.unassigned") if user.nil?

    user.full_name
  end

  def mail_to_path(email)
    "mailto:#{email}"
  end

  def converting_on_date(project)
    return project.conversion_date.to_formatted_s(:govuk) unless project.conversion_date_provisional?

    date = project.conversion_date.to_formatted_s(:govuk)
    tag = govuk_tag(text: "provisional", colour: "grey")

    "#{date} #{tag}".html_safe
  end

  def link_to_school_on_gias(urn)
    raise ArgumentError if urn.nil?

    link_to(t("project_information.show.school_details.rows.view_in_gias"), "https://get-information-schools.service.gov.uk/Establishments/Establishment/Details/#{urn}", target: :_blank)
  end

  def link_to_trust_on_gias(ukprn)
    raise ArgumentError if ukprn.nil?

    link_to(t("project_information.show.trust_details.rows.view_in_gias"), "https://get-information-schools.service.gov.uk/Groups/Search?GroupSearchModel.Text=#{ukprn}", target: :_blank)
  end

  def link_to_companies_house(companies_house_number)
    raise ArgumentError if companies_house_number.nil?

    link_to(t("project_information.show.trust_details.rows.view_companies_house"), "https://find-and-update.company-information.service.gov.uk/company/#{companies_house_number}", target: :_blank)
  end

  def all_conditions_met_tag(project)
    tag = if project.all_conditions_met?
      govuk_tag(text: "confirmed", colour: "turquoise")
    else
      govuk_tag(text: "unconfirmed", colour: "blue")
    end
    tag.to_s.html_safe
  end

  def trust_modification_order_tag(project, current_user)
    task = trust_modification_order_task(project, current_user)
    task_state = tags_for_states.fetch(task.status, tags_for_states[:unknown])

    govuk_tag(
      text: task_state[:text],
      colour: task_state[:colour]
    )
  end

  def direction_to_transfer_tag(project, current_user)
    task = direction_to_transfer_task(project, current_user)
    task_state = tags_for_states.fetch(task.status, tags_for_states[:unknown])

    govuk_tag(
      text: task_state[:text],
      colour: task_state[:colour]
    )
  end

  def address_markup(address)
    tag.address address.compact_blank.join("<br/>").html_safe, class: %w[govuk-address]
  end

  def project_notification_banner(project, user)
    if project.completed?
      render NotificationBanner
        .new(message: t("project.notifications.completed_html", date: project.completed_at.to_formatted_s(:govuk_date_time_date_only)))
    elsif project.assigned_to != user || project.assigned_to.nil?
      render NotificationBanner
        .new(message: t("project.notifications.not_assigned_html"))
    end
  end

  def academy_name(project)
    return govuk_tag(text: "Unconfirmed", colour: "grey") if project.tasks_data.academy_details_name.nil?

    project.tasks_data.academy_details_name
  end

  private def trust_modification_order_task(project, current_user)
    Conversion::Task::TrustModificationOrderTaskForm.new(project.tasks_data, current_user)
  end

  private def direction_to_transfer_task(project, current_user)
    Conversion::Task::DirectionToTransferTaskForm.new(project.tasks_data, current_user)
  end

  private def tags_for_states
    {
      not_started: {
        text: "unconfirmed",
        colour: "blue"
      },
      in_progress: {
        text: "unconfirmed",
        colour: "blue"
      },
      completed: {
        text: "needed",
        colour: "turquoise"
      },
      not_applicable: {
        text: "not applicable",
        colour: "grey"
      },
      unknown: {
        text: "unknown",
        colour: "grey"
      }
    }
  end
end
