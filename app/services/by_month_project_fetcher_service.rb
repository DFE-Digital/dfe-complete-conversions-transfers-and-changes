class ByMonthProjectFetcherService
  def initialize(pre_fetch_academies_api: true)
    @pre_fetch_academies_api = pre_fetch_academies_api
  end

  def conversion_projects_by_date_range(from_date, to_date)
    projects = Project.conversions.in_progress.confirmed.significant_date_in_range(from_date, to_date)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
  end

  def transfer_projects_by_date_range(from_date, to_date)
    projects = Project.transfers.in_progress.confirmed.significant_date_in_range(from_date, to_date)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
  end

  def conversion_projects_by_date(month, year)
    projects = Project.conversions.confirmed.filtered_by_significant_date(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  def transfer_projects_by_date(month, year)
    projects = Project.transfers.confirmed.filtered_by_significant_date(month, year)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
    sort_by_conditions_met_and_name(projects)
  end

  private def sort_by_conditions_met_and_name(projects)
    projects.sort_by { |p| [p.all_conditions_met? ? 0 : 1, p.establishment.name] }
  end
end
