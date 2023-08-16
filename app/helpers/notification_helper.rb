require "nokogiri"

module NotificationHelper
  def notification_banner_html(message)
    parsed_message = Nokogiri.parse(message)
    if parsed_message.children.count > 0
      message.html_safe
    else
      content_tag(:h3, message.html_safe, class: "govuk-notification-banner__heading").html_safe
    end
  end
end
