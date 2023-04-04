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
end
