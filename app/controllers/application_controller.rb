class ApplicationController < ActionController::Base
  include Authentication
  include Cookies
  include Pundit::Authorization
  include Pagy::Backend

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Api::AcademiesApi::Client::Error, with: :academies_api_client_error
  rescue_from Api::AcademiesApi::Client::UnauthorisedError, with: :academies_api_unauthorised_error

  def not_found_error
    render "pages/page_not_found", status: :not_found
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

  private def members_api_client_error
    render "pages/members_api_client_error", status: 500
  end
end
