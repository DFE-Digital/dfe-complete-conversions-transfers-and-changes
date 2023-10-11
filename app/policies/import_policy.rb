class ImportPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def new?
    @user.service_support_team?
  end

  def upload?
    @user.service_support_team?
  end
end
