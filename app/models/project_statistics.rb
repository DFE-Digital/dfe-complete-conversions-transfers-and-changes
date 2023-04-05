class ProjectStatistics
  def initialize
    @projects = Project.all
  end

  def total_number_of_projects
    @projects.count
  end

  def total_number_of_voluntary_projects
    @projects.voluntary.count
  end

  def total_number_of_sponsored_projects
    @projects.sponsored.count
  end

  def total_number_of_in_progress_projects
    @projects.in_progress.count
  end

  def total_number_of_completed_projects
    @projects.completed.count
  end

  def total_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.count
  end

  def voluntary_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.voluntary.count
  end

  def sponsored_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.sponsored.count
  end

  def in_progress_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.in_progress.count
  end

  def completed_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.completed.count
  end

  def total_projects_not_with_regional_casework_services
    @projects.not_assigned_to_regional_caseworker_team.count
  end

  def voluntary_projects_not_with_regional_casework_services
    @projects.not_assigned_to_regional_caseworker_team.voluntary.count
  end

  def sponsored_projects_not_with_regional_casework_services
    @projects.not_assigned_to_regional_caseworker_team.sponsored.count
  end

  def in_progress_projects_not_with_regional_casework_services
    @projects.not_assigned_to_regional_caseworker_team.in_progress.count
  end

  def completed_projects_not_with_regional_casework_services
    @projects.not_assigned_to_regional_caseworker_team.completed.count
  end
end
