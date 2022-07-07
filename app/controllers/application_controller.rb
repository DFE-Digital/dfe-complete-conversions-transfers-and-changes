class ApplicationController < ActionController::Base
  include Pundit::Authorization

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = I18n.t("unauthorised_action.message")
    redirect_back(fallback_location: root_path)
  end
end
