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

  def support_email(name = nil)
    name = Rails.application.config.support_email if name.nil?
    govuk_mail_to(Rails.application.config.support_email, name)
  end
end
