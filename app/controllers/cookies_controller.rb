class CookiesController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def edit
  end

  def update
    accept_optional_cookies = cookies_params[:accept_optional_cookies]

    unless accept_optional_cookies.nil?
      cookies[:ACCEPT_OPTIONAL_COOKIES] =
        {value: accept_optional_cookies, expires: 1.year, httponly: true}
    end

    redirect_back_or_to(cookies_path, notice: I18n.t("cookies.updated_message.#{accept_optional_cookies}"))
  end

  private def cookies_params
    params.require(:cookies_form).permit(:accept_optional_cookies)
  end
end
