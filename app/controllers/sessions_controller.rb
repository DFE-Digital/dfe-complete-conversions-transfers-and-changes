class SessionsController < ApplicationController
  skip_before_action :redirect_unauthenticated_user, only: [:new, :create, :delete, :failure]

  def new
  end

  def create
    if registered_user
      create_session
      assign_active_directory_user_id

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

  def assign_active_directory_user_id
    return if registered_user.active_directory_user_id.present?

    registered_user.update(active_directory_user_id: active_directory_user_id)
  end

  def authenticated_user_info
    request.env["omniauth.auth"].info
  end

  def active_directory_user_id
    request.env["omniauth.auth"]["uid"]
  end

  def authenticated_user_email_address
    authenticated_user_info.email.downcase
  end
end
