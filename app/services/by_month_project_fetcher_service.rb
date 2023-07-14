class ByMonthProjectFetcherService
  def initialize(prefetch: true)
    @prefetch = prefetch
  end

  def sorted_openers(month, year)
    projects = Conversion::Project.opening_by_month_year(month, year)

    if @prefetch
      pre_fetch_establishments(projects)
      pre_fetch_trusts(projects)
    end

    sort_by_conditions_met_and_name(projects)
  end

  def confirmed_openers_by_team(month, year, team)
    projects = if team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.opening_by_month_year(month, year).includes(:tasks_data)
    else
      Conversion::Project.not_assigned_to_regional_caseworker_team.by_region(team).opening_by_month_year(month, year).includes(:tasks_data)
    end

    if @prefetch
      pre_fetch_establishments(projects)
      pre_fetch_trusts(projects)
    end

    sort_by_conditions_met_and_name(projects)
  end

  private def sort_by_conditions_met_and_name(projects)
    projects.sort_by { |p| [p.all_conditions_met? ? 0 : 1, p.establishment.name] }
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcherService.new(projects).batched!
  end

  private def pre_fetch_trusts(projects)
    TrustsFetcherService.new(projects).batched!
  end
end
