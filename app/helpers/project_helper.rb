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

  def significant_date(project)
    return project.significant_date.to_formatted_s(:govuk) unless project.significant_date_provisional?

    date = project.significant_date.to_formatted_s(:govuk)
    tag = govuk_tag(text: "provisional", colour: "grey")

    "#{date} #{tag}".html_safe
  end

  def link_to_school_on_gias(urn)
    raise ArgumentError if urn.nil?

    link_to(t("project_information.show.school_details.rows.view_in_gias"), "https://get-information-schools.service.gov.uk/Establishments/Establishment/Details/#{urn}", target: :_blank)
  end

  def link_to_trust_on_gias(ukprn)
    return "" if ukprn.nil?

    link_to(t("project_information.show.trust_details.rows.view_in_gias"), "https://get-information-schools.service.gov.uk/Groups/Search?GroupSearchModel.Text=#{ukprn}", target: :_blank)
  end

  def link_to_companies_house(companies_house_number)
    raise ArgumentError if companies_house_number.nil?

    link_to(t("project_information.show.trust_details.rows.view_companies_house"), "https://find-and-update.company-information.service.gov.uk/company/#{companies_house_number}", target: :_blank)
  end

  def all_conditions_met_value(project)
    if project.all_conditions_met?
      "Yes"
    else
      "Not yet"
    end
  end

  def address_markup(address)
    tag.address address.compact_blank.join("<br/>").html_safe, class: %w[govuk-address]
  end

  def project_notification_banner(project, user)
    if project.completed?
      render NotificationBanner
        .new(message: t("project.notifications.completed_html", date: project.completed_at.to_formatted_s(:govuk_date_time_date_only)))
    elsif (project.assigned_to != user && !user.is_service_support?) || project.assigned_to.nil?
      render NotificationBanner
        .new(message: t("project.notifications.not_assigned_html"))
    end
  end

  def academy_name(project)
    return govuk_tag(text: "Unconfirmed", colour: "grey") if project.tasks_data.academy_details_name.nil?

    project.tasks_data.academy_details_name
  end

  def confirmed_date_original_date(project)
    return if project.significant_date_provisional

    confirmed_date = project.significant_date
    original_date = project.provisional_date
    "#{confirmed_date.to_fs(:govuk_short_month)} (#{original_date.to_fs(:govuk_short_month)})"
  end

  def directive_academy_order_responses
    @directive_academy_order_responses ||= [
      OpenStruct.new(id: true, name: I18n.t("helpers.responses.conversion_project.directive_academy_order.yes")),
      OpenStruct.new(id: false, name: I18n.t("helpers.responses.conversion_project.directive_academy_order.no"))
    ]
  end

  def yes_no_responses
    @yes_no_responses ||= [
      OpenStruct.new(id: true, name: I18n.t("yes")),
      OpenStruct.new(id: false, name: I18n.t("no"))
    ]
  end

  def project_type_as_string(project)
    ActiveSupport::Inflector.deconstantize(project.type).downcase
  end

  def projects_establishment_name_list(project_group)
    name_list = project_group.projects.map do |project|
      project.establishment.name
    end
    name_list.join("; ")
  end
end
