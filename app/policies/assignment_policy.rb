class AssignmentPolicy
  attr_reader :user

  def initialize(user, _assignment)
    @user = user
  end

  def assign_team_leader?
    return true if @user.is_service_support?

    @user.manage_team?
  end

  def update_team_leader?
    assign_team_leader?
  end

  def assign_regional_delivery_officer?
    return true if @user.is_service_support?

    @user.manage_team?
  end

  def update_regional_delivery_officer?
    assign_regional_delivery_officer?
  end

  def assign_assigned_to?
    return true if @user.is_service_support?

    @user.has_role?
  end

  def update_assigned_to?
    assign_assigned_to?
  end

  def assign_team?
    return true if @user.is_service_support?

    @user.has_role?
  end

  def update_team?
    assign_team?
  end
end
