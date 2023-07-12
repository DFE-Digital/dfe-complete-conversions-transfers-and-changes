class SessionsController < ApplicationController
  skip_before_action :redirect_unauthenticated_user, only: [:new, :create, :delete, :failure]

  def new
  end

  def create
    if registered_user
      create_session

      return redirect_to users_team_path if current_user.team.nil?

      redirect_to root_path
    else
      return redirect_inactive_user if inactive_user?

      redirect_unknown_user
    end
  end

  def delete
    reset_session
    redirect_to sign_in_path, notice: I18n.t("sign_out.message.success")
  end

  def failure
    redirect_to sign_in_path, notice: I18n.t("sign_in.message.failure")
  end

  private def registered_user
    @registered_user ||= User.active.find_by(email: authenticated_user_email_address)
  end

  private def inactive_user?
    User.inactive.find_by(email: authenticated_user_email_address)
  end

  private def create_session
    assign_active_directory_user_id
    assign_active_directory_user_group_ids
    session[:user_id] = registered_user.id
  end

  private def assign_active_directory_user_id
    return if registered_user.active_directory_user_id.present?

    registered_user.update_attribute(:active_directory_user_id, active_directory_user_id)
  end

  private def assign_active_directory_user_group_ids
    registered_user.update_attribute(:active_directory_user_group_ids, active_directory_user_group_ids)
  end

  private def authenticated_user_info
    request.env["omniauth.auth"].info
  end

  private def active_directory_user_id
    request.env["omniauth.auth"]["uid"]
  end

  private def active_directory_user_group_ids
    request.env["omniauth.auth"].dig("extra", "raw_info", "groups").to_a
  end

  private def authenticated_user_email_address
    authenticated_user_info.email.downcase
  end

  private def redirect_unknown_user
    redirect_to sign_in_path, alert: I18n.t("unknown_user.message", email_address: authenticated_user_email_address)
  end

  private def redirect_inactive_user
    redirect_to sign_in_path, notice: I18n.t("inactive_user.message", email_address: authenticated_user_email_address)
  end
end
