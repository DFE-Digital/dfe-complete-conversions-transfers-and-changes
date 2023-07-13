class ProjectsForExportService
  def risk_protection_arrangement_projects(month:, year:)
    projects = projects_by_month_and_year(month, year)
    pre_fetch_entities!(projects)
    projects
  end

  def funding_agreement_letters_projects(month:, year:)
    projects = projects_by_month_and_year(month, year)
    pre_fetch_entities!(projects)
    projects
  end

  private def projects_by_month_and_year(month, year)
    Conversion::Project.opening_by_month_year(month, year)
  end

  private def pre_fetch_entities!(projects)
    EstablishmentsFetcherService.new(projects).batched!
    TrustsFetcherService.new(projects).batched!
  end
end
