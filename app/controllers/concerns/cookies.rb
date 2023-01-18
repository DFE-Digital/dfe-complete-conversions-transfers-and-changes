module Cookies
  extend ActiveSupport::Concern

  included do
    before_action :get_cookies
  end

  private def get_cookies
    @cookie_form = CookiesForm.new(accept_optional_cookies: get_cookie_value)
  end

  private def get_cookie_value
    return false unless cookies[:ACCEPT_OPTIONAL_COOKIES].present?

    JSON.parse(cookies[:ACCEPT_OPTIONAL_COOKIES])
  end
end
