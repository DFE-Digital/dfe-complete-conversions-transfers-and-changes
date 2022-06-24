class SessionsController < ApplicationController
  def new
  end

  def create
    if registered_user
      create_session
      redirect_to root_path
    else
      redirect_to sign_in_path, notice: I18n.t("unknown_user.message", email_address: authenticated_user_email_address)
    end
  end

  def delete
    session.destroy
    redirect_to sign_in_path, notice: I18n.t("sign_out.message.success")
  end

  def failure
    redirect_to sign_in_path, notice: I18n.t("sign_in.message.failure")
  end

  private

  def registered_user
    @registered_user ||= User.find_by(email: authenticated_user_email_address)
  end

  def create_session
    session[:user_id] = registered_user.id
  end

  def authenticated_user_info
    request.env["omniauth.auth"].info
  end

  def authenticated_user_email_address
    authenticated_user_info.email.downcase
  end
end
