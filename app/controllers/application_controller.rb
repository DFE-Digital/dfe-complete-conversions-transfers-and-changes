class ApplicationController < ActionController::Base
  include Authentication
  include Cookies
  include Pundit::Authorization
  include Pagy::Backend

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Api::AcademiesApi::Client::Error, with: :academies_api_client_error
  rescue_from Api::AcademiesApi::Client::UnauthorisedError, with: :academies_api_unauthorised_error
  rescue_from ActionController::InvalidAuthenticityToken, with: :reset_user_session

  before_action :current_user_identifier
  before_action :set_notification

  def not_found_error
    render "pages/page_not_found", status: :not_found
  end

  def current_user_identifier
    @current_user_identifier = current_user ? current_user.email : "Anonymous"
  end

  private def reset_user_session
    redirect_to sign_out_path
  end

  private def set_notification
    request.env["exception_notifier.exception_data"] = {
      "timestamp" => Time.current.to_s,
      "user_environment" => user_environment,
      "current_user" => current_user_identifier
    }
  end

  private def user_environment
    ENV["USER_ENV"] || Rails.env
  end

  private def user_not_authorized
    flash[:alert] = I18n.t("unauthorised_action.message")
    redirect_back(fallback_location: root_path)
  end

  private def academies_api_client_error
    render "pages/academies_api_client_timeout", status: 500
  end

  private def academies_api_unauthorised_error
    render "pages/academies_api_client_unauthorised", status: 401
  end
end
