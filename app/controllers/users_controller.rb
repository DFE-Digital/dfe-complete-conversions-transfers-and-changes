class UsersController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize User

    @pager, @users = pagy(User.order_by_first_name)
  end
end
