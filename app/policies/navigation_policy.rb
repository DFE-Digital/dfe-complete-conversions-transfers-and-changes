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
    return true if @user.caseworker?
    return true if @user.regional_delivery_officer?

    false
  end

  def show_team_projects_header_navigation?
    return true if @user.team_leader?

    false
  end

  def show_all_projects_header_navigation?
    return true if show_your_projects_header_navigation?
    return true if show_team_projects_header_navigation?
    return true if show_service_support_header_navigation?

    false
  end

  def show_service_support_header_navigation?
    return true if @user.service_support?

    false
  end
end
