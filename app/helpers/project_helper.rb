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
    date = project.provisional_conversion_date.to_formatted_s(:govuk)
    tag = govuk_tag(text: "provisional", colour: "grey")

    "#{date} #{tag}".html_safe
  end
end
