module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :redirect_unauthenticated_user, :current_user

    helper_method :current_user
  end

  private def redirect_unauthenticated_user
    redirect_to sign_in_path, notice: I18n.t("sign_in.message.unauthenticated") unless user_authenticated?
  end

  private def current_user
    return unless user_authenticated?

    @current_user ||= User.find(current_user_id)
  end

  private def user_authenticated?
    current_user_id.present?
  end

  private def current_user_id
    session[:user_id]
  end
end
