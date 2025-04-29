class ReroutingPolicy
  def initialize(user, _record = nil)
    @user = user
  end

  def show?
    @user.team == "service_support" || @user.capabilities.include?(Capability.devops)
  end
end
