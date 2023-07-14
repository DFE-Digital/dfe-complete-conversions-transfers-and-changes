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

  private def sort_by_conditions_met_and_name(projects)
    projects.sort_by { |p| [p.all_conditions_met? ? 0 : 1, p.establishment.name] }
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcherService.new(projects).call!
  end

  private def pre_fetch_trusts(projects)
    TrustsFetcherService.new(projects).call!
  end
end
