class ProjectsForExportService
  def conversion_projects_by_advisory_board_date(month:, year:)
    projects = Conversion::Project.filtered_by_advisory_board_date(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def transfer_projects_by_advisory_board_date(month:, year:)
    projects = Transfer::Project.filtered_by_advisory_board_date(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def transfer_projects_by_significant_date(month:, year:)
    projects = Transfer::Project.filtered_by_significant_date(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end
end
