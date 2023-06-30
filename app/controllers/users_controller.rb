class UsersController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize User

    @pager, @users = pagy(User.order_by_first_name)
  end

  def new
    authorize User
    @user = User.new
  end

  def create
    authorize User

    @user = User.new(user_params)

    if @user.valid?
      @user.save
      redirect_to users_path, notice: I18n.t("user.add.success", email: @user.email)
    else
      render :new
    end
  end

  private def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :team,
      :team_leader
    )
  end
end
