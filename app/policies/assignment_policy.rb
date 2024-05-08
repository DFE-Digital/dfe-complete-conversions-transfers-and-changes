class AssignmentPolicy
  attr_reader :user

  def initialize(user, _assignment)
    @user = user
  end

  def edit_assigned_user?
    return true if @user.is_service_support?

    @user.has_role?
  end

  def update_assigned_user?
    edit_assigned_user?
  end

  def assign_team_leader?
    team_lead_or_service_support?
  end

  def update_team_leader?
    assign_team_leader?
  end

  def edit_added_by_user?
    team_lead_or_service_support?
  end

  def update_added_by_user?
    edit_added_by_user?
  end

  def assign_regional_delivery_officer?
    edit_added_by_user?
  end

  def update_regional_delivery_officer?
    edit_added_by_user?
  end

  def assign_team?
    return true if @user.is_service_support?

    @user.has_role?
  end

  def update_team?
    assign_team?
  end

  private def team_lead_or_service_support?
    @user.is_service_support? || @user.manage_team?
  end
end
