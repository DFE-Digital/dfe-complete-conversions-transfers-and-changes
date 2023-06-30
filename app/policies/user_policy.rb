class UserPolicy
  attr_reader :user, :user_account

  def initialize(user, user_account)
    @user = user
    @user_account = user_account
  end

  def index?
    @user.service_support?
  end

  def new?
    index?
  end

  def create?
    index?
  end
end
