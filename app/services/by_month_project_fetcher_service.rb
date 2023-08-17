class ByMonthProjectFetcherService
  def initialize(pre_fetch_academies_api: true)
    @pre_fetch_academies_api = pre_fetch_academies_api
  end

  def confirmed(month, year)
    projects = Project.confirmed.filtered_by_significant_date(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_transfers(month, year)
    projects = Transfer::Project.confirmed.filtered_by_significant_date(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_conversions(month, year)
    projects = Conversion::Project.confirmed.filtered_by_significant_date(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised(month, year)
    projects = Project.significant_date_revised_from(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised_transfers(month, year)
    projects = Transfer::Project.significant_date_revised_from(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised_conversions(month, year)
    projects = Conversion::Project.significant_date_revised_from(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_openers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Project.assigned_to_regional_caseworker_team.confirmed.filtered_by_significant_date(month, year)
    else
      Project.not_assigned_to_regional_caseworker_team.by_region(team).confirmed.filtered_by_significant_date(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_conversions_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.confirmed.filtered_by_significant_date(month, year)
    else
      Conversion::Project.not_assigned_to_regional_caseworker_team.by_region(team).confirmed.filtered_by_significant_date(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_transfers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Transfer::Project.assigned_to_regional_caseworker_team.confirmed.filtered_by_significant_date(month, year)
    else
      Transfer::Project.not_assigned_to_regional_caseworker_team.by_region(team).confirmed.filtered_by_significant_date(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised_openers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Project.assigned_to_regional_caseworker_team.significant_date_revised_from(month, year)
    else
      Project.not_assigned_to_regional_caseworker_team.by_region(team).significant_date_revised_from(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised_conversions_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.significant_date_revised_from(month, year)
    else
      Conversion::Project.not_assigned_to_regional_caseworker_team.by_region(team).significant_date_revised_from(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def revised_transfers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Transfer::Project.assigned_to_regional_caseworker_team.significant_date_revised_from(month, year)
    else
      Transfer::Project.not_assigned_to_regional_caseworker_team.by_region(team).significant_date_revised_from(month, year)
    end

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  private def sort_by_conditions_met_and_name(projects)
    projects.sort_by { |p| [p.all_conditions_met? ? 0 : 1, p.establishment.name] }
  end
end
