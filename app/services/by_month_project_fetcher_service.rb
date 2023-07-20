class ByMonthProjectFetcherService
  def initialize(pre_fetch_academies_api: true)
    @pre_fetch_academies_api = pre_fetch_academies_api
  end

  def sorted_openers(month, year)
    projects = Conversion::Project.includes(:tasks_data).opening_by_month_year(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_openers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.includes(:tasks_data).opening_by_month_year(month, year)
    else
      Conversion::Project.not_assigned_to_regional_caseworker_team.by_region(team).includes(:tasks_data).opening_by_month_year(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised_openers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.includes(:tasks_data).conversion_date_revised_from(month, year)
    else
      Conversion::Project.not_assigned_to_regional_caseworker_team.by_region(team).includes(:tasks_data).conversion_date_revised_from(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  private def sort_by_conditions_met_and_name(projects)
    projects.sort_by { |p| [p.all_conditions_met? ? 0 : 1, p.establishment.name] }
  end
end
