class AssignmentPolicy
  attr_reader :user

  def initialize(user, _assignment)
    @user = user
  end

  def edit_assigned_user?
    user_has_role_or_service_support?
  end

  def update_assigned_user?
    edit_assigned_user?
  end

  def edit_added_by_user?
    team_lead_or_service_support?
  end

  def update_added_by_user?
    edit_added_by_user?
  end

  def edit_team?
    user_has_role_or_service_support?
  end

  def update_team?
    edit_team?
  end

  private def user_has_role_or_service_support?
    @user.has_role? || @user.is_service_support?
  end

  private def team_lead_or_service_support?
    @user.is_service_support? || @user.manage_team?
  end
end
