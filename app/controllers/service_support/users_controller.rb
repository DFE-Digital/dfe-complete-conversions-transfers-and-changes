class ServiceSupport::UsersController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index_active
    authorize User, :index?

    @pager, @users = pagy(User.active.order_by_first_name)
  end

  def index_inactive
    authorize User, :index?

    @pager, @users = pagy(User.inactive.order_by_first_name)
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
      send_new_account_email(@user)
      redirect_to service_support_users_path, notice: I18n.t("user.add.success", email: @user.email)
    else
      render :new
    end
  end

  def edit
    @user = User.find(user_id)
    authorize @user
  end

  def update
    @user = User.find(user_id)
    authorize @user

    @user.assign_attributes(user_params)
    if @user.valid?
      @user.save!
      assign_capabilities
      redirect_to service_support_users_path, notice: I18n.t("user.edit.success", email: @user.email)
    else
      render :edit
    end
  end

  def set_team
    @user = current_user
    authorize @user
  end

  def update_team
    @user = current_user
    authorize @user

    @user.assign_attributes(team_params)
    if @user.valid?
      @user.save!(context: :set_team)
      redirect_to root_path, notice: I18n.t("user.set_team.success", email: @user.email)
    else
      render :set_team
    end
  end

  private def assign_capabilities
    desired_capabilities = params[:user][:capabilities].map do |name|
      Capability.find_by(name: name)
    end.compact

    @user.capabilities = desired_capabilities
  end

  private def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :team,
      :manage_team,
      :active
    )
  end

  private def user_id
    params[:id]
  end

  private def team_params
    params.require(:user).permit(:team)
  end

  private def send_new_account_email(user)
    UserAccountMailer.new_account_added(user).deliver_later
  end
end
