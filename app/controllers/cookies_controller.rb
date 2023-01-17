class CookiesController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def edit
    @cookie_form = CookiesForm.new(accept_optional_cookies: get_cookie_value)
  end

  def update
    cookie_value = cookies_params[:accept_optional_cookies]
    cookies[:ACCEPT_OPTIONAL_COOKIES] = {value: cookie_value, expires: 1.year}
  end

  private def get_cookie_value
    return false unless cookies[:ACCEPT_OPTIONAL_COOKIES].present?

    JSON.parse(cookies[:ACCEPT_OPTIONAL_COOKIES])
  end

  private def cookies_params
    params.require(:cookies_form).permit(:accept_optional_cookies)
  end
end
