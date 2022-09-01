module ProjectInformationHelper
  def age_range(establishment)
    return nil if establishment.age_range_lower.blank? || establishment.age_range_upper.blank?

    "#{establishment.age_range_lower} to #{establishment.age_range_upper}"
  end

  def display_name(user)
    return t("project_information.show.project_details.rows.unassigned") if user.nil?

    return govuk_mail_to(user.email, user.email) if user.full_name.blank?

    sanitize "#{user.full_name} (#{govuk_mail_to(user.email, user.email)})"
  end
end
