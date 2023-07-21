class ProjectsForExportService
  def risk_protection_arrangement_projects(month:, year:)
    projects = projects_by_month_and_year(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def funding_agreement_letters_projects(month:, year:)
    projects = projects_by_month_and_year(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  private def projects_by_month_and_year(month, year)
    Conversion::Project.opening_by_month_year(month, year)
  end
end
