class NotificationBanner < ViewComponent::Base
  def initialize(flashes:)
    @flashes = flashes
  end
end
