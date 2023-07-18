class UserPolicy
  attr_reader :user, :user_account

  def initialize(user, user_account)
    @user = user
    @user_account = user_account
  end

  def index?
    @user.manage_user_accounts?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def set_team?
    @user == @user_account
  end

  def update_team?
    set_team?
  end
end
