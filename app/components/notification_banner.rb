class NotificationBanner < ViewComponent::Base
  def initialize(flashes: nil, message: nil)
    @flashes = flashes
    @message = message
  end
end
