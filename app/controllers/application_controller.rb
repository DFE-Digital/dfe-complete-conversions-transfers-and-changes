class ApplicationController < ActionController::Base
  include Authentication
  include Cookies
  include Pundit::Authorization
  include Pagy::Backend

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from AcademiesApi::Client::Error, with: :client_error

  private def user_not_authorized
    flash[:alert] = I18n.t("unauthorised_action.message")
    redirect_back(fallback_location: root_path)
  end

  private def client_error
    render "pages/api_client_timeout", status: 500
  end

  private def not_found_error
    render "pages/page_not_found", status: :not_found
  end
end
