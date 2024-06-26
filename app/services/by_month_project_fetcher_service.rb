class ByMonthProjectFetcherService
  def initialize(pre_fetch_academies_api: true)
    @pre_fetch_academies_api = pre_fetch_academies_api
  end

  def conversion_projects_by_date_range(from_date, to_date)
    projects = Project.active.conversions.in_progress.confirmed.significant_date_in_range(from_date, to_date)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
  end

  def transfer_projects_by_date_range(from_date, to_date)
    projects = Project.active.transfers.in_progress.confirmed.significant_date_in_range(from_date, to_date)

    AcademiesApiPreFetcherService.new.call!(projects) if @pre_fetch_academies_api
  end
end
