class NotificationBanner < ViewComponent::Base
  delegate :notification_banner_html, to: :helpers

  def initialize(flashes: nil, message: nil)
    @flashes = flashes
    @message = message
  end
end
