class Statistics::ProjectStatistics
  def initialize
    @conversion_projects = Conversion::Project.not_deleted
    @transfer_projects = Transfer::Project.not_deleted
  end

  def total_number_of_conversion_projects
    @conversion_projects.count
  end

  def total_number_of_transfer_projects
    @transfer_projects.count
  end

  def total_number_of_in_progress_conversion_projects
    @conversion_projects.in_progress.count
  end

  def total_number_of_in_progress_transfer_projects
    @transfer_projects.in_progress.count
  end

  def total_number_of_unassigned_conversion_projects
    @conversion_projects.unassigned_to_user.count
  end

  def total_number_of_unassigned_transfer_projects
    @transfer_projects.unassigned_to_user.count
  end

  def total_number_of_completed_conversion_projects
    @conversion_projects.completed.count
  end

  def total_number_of_completed_transfer_projects
    @transfer_projects.completed.count
  end

  def total_number_of_dao_revoked_conversion_projects
    @projects.dao_revoked.count
  end

  def total_conversion_projects_with_regional_casework_services
    @conversion_projects.assigned_to_regional_caseworker_team.count
  end

  def total_transfer_projects_with_regional_casework_services
    @transfer_projects.assigned_to_regional_caseworker_team.count
  end

  def in_progress_conversion_projects_with_regional_casework_services
    @conversion_projects.assigned_to_regional_caseworker_team.in_progress.count
  end

  def in_progress_transfer_projects_with_regional_casework_services
    @transfer_projects.assigned_to_regional_caseworker_team.in_progress.count
  end

  def completed_conversion_projects_with_regional_casework_services
    @conversion_projects.assigned_to_regional_caseworker_team.completed.count
  end

  def completed_transfer_projects_with_regional_casework_services
    @transfer_projects.assigned_to_regional_caseworker_team.completed.count
  end

  def unassigned_conversion_projects_with_regional_casework_services
    @conversion_projects.assigned_to_regional_caseworker_team.unassigned_to_user.count
  end

  def unassigned_transfer_projects_with_regional_casework_services
    @transfer_projects.assigned_to_regional_caseworker_team.unassigned_to_user.count
  end

  def total_conversion_projects_not_with_regional_casework_services
    @conversion_projects.not_assigned_to_regional_caseworker_team.count
  end

  def total_transfer_projects_not_with_regional_casework_services
    @transfer_projects.not_assigned_to_regional_caseworker_team.count
  end

  def in_progress_conversion_projects_not_with_regional_casework_services
    @conversion_projects.not_assigned_to_regional_caseworker_team.in_progress.count
  end

  def in_progress_transfer_projects_not_with_regional_casework_services
    @transfer_projects.not_assigned_to_regional_caseworker_team.in_progress.count
  end

  def completed_conversion_projects_not_with_regional_casework_services
    @conversion_projects.not_assigned_to_regional_caseworker_team.completed.count
  end

  def completed_transfer_projects_not_with_regional_casework_services
    @transfer_projects.not_assigned_to_regional_caseworker_team.completed.count
  end

  def unassigned_conversion_projects_not_with_regional_casework_services
    @conversion_projects.not_assigned_to_regional_caseworker_team.unassigned_to_user.count
  end

  def unassigned_transfer_projects_not_with_regional_casework_services
    @transfer_projects.not_assigned_to_regional_caseworker_team.unassigned_to_user.count
  end

  def conversion_project_statistics_for_region(region)
    OpenStruct.new(
      total: @conversion_projects.by_region(region).count,
      in_progress: @conversion_projects.by_region(region).in_progress.count,
      completed: @conversion_projects.by_region(region).completed.count,
      unassigned: @conversion_projects.by_region(region).unassigned_to_user.count
    )
  end

  def transfer_project_statistics_for_region(region)
    OpenStruct.new(
      total: @transfer_projects.by_region(region).count,
      in_progress: @transfer_projects.by_region(region).in_progress.count,
      completed: @transfer_projects.by_region(region).completed.count,
      unassigned: @transfer_projects.by_region(region).unassigned_to_user.count
    )
  end

  def opener_date_and_project_total
    hash = {}
    (1..6).each do |i|
      date = Date.today + i.month
      hash["#{date.month}/#{date.year}"] = {
        conversions: @conversion_projects.confirmed.filtered_by_significant_date(date.month, date.year).count,
        transfers: @transfer_projects.confirmed.filtered_by_significant_date(date.month, date.year).count
      }
    end
    hash
  end

  def new_projects_this_month
    transfers_count = @transfer_projects.where("created_at >= ?", Time.now.beginning_of_month).where("created_at <= ?", Time.now.end_of_month).count
    conversions_count = @conversion_projects.where("created_at >= ?", Time.now.beginning_of_month).where("created_at <= ?", Time.now.end_of_month).count

    OpenStruct.new(
      total: transfers_count + conversions_count,
      transfers: transfers_count,
      conversions: conversions_count
    )
  end
end
