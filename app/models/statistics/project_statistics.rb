class Statistics::ProjectStatistics
  def initialize
    @projects = Conversion::Project.all
  end

  def total_number_of_projects
    @projects.count
  end

  def total_number_of_in_progress_projects
    @projects.in_progress.count
  end

  def total_number_of_unassigned_projects
    @projects.unassigned_to_user.count
  end

  def total_number_of_completed_projects
    @projects.completed.count
  end

  def total_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.count
  end

  def in_progress_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.in_progress.count
  end

  def completed_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.completed.count
  end

  def unassigned_projects_with_regional_casework_services
    @projects.assigned_to_regional_caseworker_team.unassigned_to_user.count
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

  def unassigned_projects_not_with_regional_casework_services
    @projects.not_assigned_to_regional_caseworker_team.unassigned_to_user.count
  end

  def statistics_for_region(region)
    OpenStruct.new(
      total: @projects.by_region(region).count,
      in_progress: @projects.by_region(region).in_progress.count,
      completed: @projects.by_region(region).completed.count,
      unassigned: @projects.by_region(region).unassigned_to_user.count
    )
  end

  def opener_date_and_project_total
    hash = {}
    (1..6).each do |i|
      date = Date.today + i.month
      hash["#{Date::MONTHNAMES[date.month]} #{date.year}"] = Conversion::Project.confirmed.filtered_by_significant_date(date.month, date.year).count
    end
    hash
  end
end
