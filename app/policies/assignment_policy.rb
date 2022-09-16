class AssignmentPolicy
  attr_reader :user

  def initialize(user, _assignment)
    @user = user
  end

  def assign_team_leader?
    @user.team_leader?
  end

  def update_team_leader?
    assign_team_leader?
  end

  def assign_regional_delivery_officer?
    @user.team_leader?
  end

  def update_regional_delivery_officer?
    assign_regional_delivery_officer?
  end

  def assign_caseworker?
    @user.team_leader?
  end

  def update_caseworker?
    assign_caseworker?
  end
end
