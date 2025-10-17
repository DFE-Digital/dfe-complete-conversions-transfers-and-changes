class SessionsController < ApplicationController
  skip_before_action :redirect_unauthenticated_user, only: [:new, :create, :delete, :failure]

  def new
  end

  def create
    if registered_user
      create_session

      return redirect_to service_support_users_team_path if current_user.team.nil?

      redirect_to root_path
    else
      return redirect_inactive_user if inactive_user?
      
      # Check if it's a duplicate ADID issue
      return redirect_duplicate_user if duplicate_adid_detected?

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
    # First try to find by ADID (source of truth)
    if active_directory_user_id.present?
      @users_by_adid = User.active.where(active_directory_user_id: active_directory_user_id)
      
      if @users_by_adid.count > 1
        # Multiple users with same ADID - this is a data problem
        Rails.logger.error("[SessionsController] Duplicate ADID detected: #{active_directory_user_id}")
        notify_ops_of_duplicate_adid(@users_by_adid)
        return nil # Will trigger duplicate user flow
      elsif @users_by_adid.count == 1
        # Found user by ADID - this handles email renames correctly
        Rails.logger.info("[SessionsController] User resolved by ADID: #{@users_by_adid.first.id}")
        return @users_by_adid.first
      end
    end
    
    # Fallback to email if no ADID match
    User.active.find_by(email: authenticated_user_email_address)
  end

  private def inactive_user?
    User.inactive.find_by(email: authenticated_user_email_address)
  end

  private def create_session
    assign_active_directory_user_id
    assign_active_directory_user_group_ids
    update_latest_session_for_user
    session[:user_id] = registered_user.id
  end

  private def assign_active_directory_user_id
    return if registered_user.active_directory_user_id.present?

    registered_user.update_attribute(:active_directory_user_id, active_directory_user_id)
  end

  private def assign_active_directory_user_group_ids
    registered_user.update_attribute(:active_directory_user_group_ids, active_directory_user_group_ids)
  end

  private def update_latest_session_for_user
    registered_user.update(latest_session: DateTime.now)
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

  private def duplicate_adid_detected?
    active_directory_user_id.present? && @users_by_adid&.count && @users_by_adid.count > 1
  end

  private def redirect_duplicate_user
    redirect_to sign_in_path, alert: I18n.t("duplicate_user.message")
  end

  private def notify_ops_of_duplicate_adid(users)
    user_details = users.map { |u| "ID: #{u.id}, Email: #{u.email}, Created: #{u.created_at}" }.join("; ")
    
    Ops::ErrorNotification.new.handled(
      message: "Duplicate active_directory_user_id detected during login",
      user: authenticated_user_email_address,
      path: "SessionsController",
      metadata: {
        active_directory_user_id: active_directory_user_id,
        duplicate_users: user_details
      }
    )
  rescue => e
    Rails.logger.error("[SessionsController] Failed to send ops notification: #{e.message}")
  end
end
