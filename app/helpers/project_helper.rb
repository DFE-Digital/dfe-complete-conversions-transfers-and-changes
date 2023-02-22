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
    conversion_date = project.conversion_date

    return conversion_date.date.to_formatted_s(:govuk) unless conversion_date.provisional?

    date = conversion_date.date.to_formatted_s(:govuk)
    tag = govuk_tag(text: "provisional", colour: "grey")

    "#{date} #{tag}".html_safe
  end

  def link_to_school_on_gias(urn)
    raise ArgumentError if urn.nil?

    link_to(t("project_information.show.school_details.rows.view_in_gias"), "https://get-information-schools.service.gov.uk/Establishments/Establishment/Details/#{urn}", target: :_blank)
  end
end
