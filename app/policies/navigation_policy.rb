class NavigationPolicy
  def initialize(user, _record)
    @user = user
  end

  def show_header_navigation?
    return false if @user.nil?

    return true if show_your_projects_header_navigation?
    return true if show_team_projects_header_navigation?
    return true if show_service_support_header_navigation?

    false
  end

  def show_your_projects_header_navigation?
    return true if @user.assign_to_project?
    return true if @user.add_new_project?

    false
  end

  def show_team_projects_header_navigation?
    return false unless @user.has_role?
    return true unless @user.team.nil?

    false
  end

  def show_all_projects_header_navigation?
    return true if show_your_projects_header_navigation?
    return true if show_team_projects_header_navigation?
    return true if show_service_support_header_navigation?

    false
  end

  def show_service_support_header_navigation?
    return true if @user.service_support_team?

    false
  end
end
