class ProjectStatistics
  def initialize
    @projects = Conversion::Project.all
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

  def total_number_of_unassigned_projects
    @projects.unassigned_to_user.count
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

  def total_projects_within_london_region
    @projects.by_region("london").count
  end

  def voluntary_projects_within_london_region
    @projects.by_region("london").voluntary.count
  end

  def sponsored_projects_within_london_region
    @projects.by_region("london").sponsored.count
  end

  def in_progress_projects_within_london_region
    @projects.by_region("london").in_progress.count
  end

  def completed_projects_within_london_region
    @projects.by_region("london").completed.count
  end

  def total_projects_within_south_east_region
    @projects.by_region("south_east").count
  end

  def voluntary_projects_within_south_east_region
    @projects.by_region("south_east").voluntary.count
  end

  def sponsored_projects_within_south_east_region
    @projects.by_region("south_east").sponsored.count
  end

  def in_progress_projects_within_south_east_region
    @projects.by_region("south_east").in_progress.count
  end

  def completed_projects_within_south_east_region
    @projects.by_region("south_east").completed.count
  end

  def total_projects_within_yorkshire_and_the_humber_region
    @projects.by_region("yorkshire_and_the_humber").count
  end

  def voluntary_projects_within_yorkshire_and_the_humber_region
    @projects.by_region("yorkshire_and_the_humber").voluntary.count
  end

  def sponsored_projects_within_yorkshire_and_the_humber_region
    @projects.by_region("yorkshire_and_the_humber").sponsored.count
  end

  def in_progress_projects_within_yorkshire_and_the_humber_region
    @projects.by_region("yorkshire_and_the_humber").in_progress.count
  end

  def completed_projects_within_yorkshire_and_the_humber_region
    @projects.by_region("yorkshire_and_the_humber").completed.count
  end

  def total_projects_within_north_west_region
    @projects.by_region("north_west").count
  end

  def voluntary_projects_within_north_west_region
    @projects.by_region("north_west").voluntary.count
  end

  def sponsored_projects_within_north_west_region
    @projects.by_region("north_west").sponsored.count
  end

  def in_progress_projects_within_north_west_region
    @projects.by_region("north_west").in_progress.count
  end

  def completed_projects_within_north_west_region
    @projects.by_region("north_west").completed.count
  end

  def total_projects_within_east_of_england_region
    @projects.by_region("east_of_england").count
  end

  def voluntary_projects_within_east_of_england_region
    @projects.by_region("east_of_england").voluntary.count
  end

  def sponsored_projects_within_east_of_england_region
    @projects.by_region("east_of_england").sponsored.count
  end

  def in_progress_projects_within_east_of_england_region
    @projects.by_region("east_of_england").in_progress.count
  end

  def completed_projects_within_east_of_england_region
    @projects.by_region("east_of_england").completed.count
  end

  def total_projects_within_west_midlands_region
    @projects.by_region("west_midlands").count
  end

  def voluntary_projects_within_west_midlands_region
    @projects.by_region("west_midlands").voluntary.count
  end

  def sponsored_projects_within_west_midlands_region
    @projects.by_region("west_midlands").sponsored.count
  end

  def in_progress_projects_within_west_midlands_region
    @projects.by_region("west_midlands").in_progress.count
  end

  def completed_projects_within_west_midlands_region
    @projects.by_region("west_midlands").completed.count
  end

  def total_projects_within_north_east_region
    @projects.by_region("north_east").count
  end

  def voluntary_projects_within_north_east_region
    @projects.by_region("north_east").voluntary.count
  end

  def sponsored_projects_within_north_east_region
    @projects.by_region("north_east").sponsored.count
  end

  def in_progress_projects_within_north_east_region
    @projects.by_region("north_east").in_progress.count
  end

  def completed_projects_within_north_east_region
    @projects.by_region("north_east").completed.count
  end

  def total_projects_within_south_west_region
    @projects.by_region("south_west").count
  end

  def voluntary_projects_within_south_west_region
    @projects.by_region("south_west").voluntary.count
  end

  def sponsored_projects_within_south_west_region
    @projects.by_region("south_west").sponsored.count
  end

  def in_progress_projects_within_south_west_region
    @projects.by_region("south_west").in_progress.count
  end

  def completed_projects_within_south_west_region
    @projects.by_region("south_west").completed.count
  end

  def total_projects_within_east_midlands_region
    @projects.by_region("east_midlands").count
  end

  def voluntary_projects_within_east_midlands_region
    @projects.by_region("east_midlands").voluntary.count
  end

  def sponsored_projects_within_east_midlands_region
    @projects.by_region("east_midlands").sponsored.count
  end

  def in_progress_projects_within_east_midlands_region
    @projects.by_region("east_midlands").in_progress.count
  end

  def completed_projects_within_east_midlands_region
    @projects.by_region("east_midlands").completed.count
  end

  def unassigned_projects_in_region(region)
    @projects.by_region(region).unassigned_to_user.count
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
