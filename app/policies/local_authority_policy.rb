class LocalAuthorityPolicy
  attr_reader :user

  def initialize(user, local_authority)
    @user = user
    @local_authority = local_authority
  end

  def new?
    return true if @user.manage_local_authorities?
    false
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end

  def confirm_destroy?
    destroy?
  end
end
