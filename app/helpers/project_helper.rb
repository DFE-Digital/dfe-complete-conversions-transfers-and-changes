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

    date = project.provisional_conversion_date.to_formatted_s(:govuk)
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

  def all_conditions_met_tag(project)
    tag = if project.all_conditions_met?
      govuk_tag(text: "yes", colour: "turquoise")
    else
      govuk_tag(text: "not started", colour: "blue")
    end
    tag.to_s.html_safe
  end

  def address_markup(address)
    tag.address address.compact.join("<br/>").html_safe, class: %w[govuk-address]
  end
end
