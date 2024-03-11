class ProjectsForExportService
  def risk_protection_arrangement_projects(month:, year:)
    projects = conversion_projects_by_month_and_year(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def funding_agreement_letters_projects(month:, year:)
    projects = conversion_projects_by_month_and_year(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def grant_management_and_finance_unit_conversion_projects(month:, year:)
    projects = conversion_projects_by_advisory_board_date(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def grant_management_and_finance_unit_transfer_projects(month:, year:)
    projects = transfer_projects_by_advisory_board_date(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def transfer_by_month_projects(month:, year:)
    projects = transfer_projects_by_month_and_year(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  def conversion_by_month_projects(month:, year:)
    projects = conversion_projects_by_month_and_year(month, year)
    AcademiesApiPreFetcherService.new.call!(projects)
  end

  private def transfer_projects_by_month_and_year(month, year)
    Transfer::Project.filtered_by_significant_date(month, year)
  end

  private def conversion_projects_by_month_and_year(month, year)
    Conversion::Project.filtered_by_significant_date(month, year)
  end

  private def conversion_projects_by_advisory_board_date(month, year)
    Conversion::Project.filtered_by_advisory_board_date(month, year)
  end

  private def transfer_projects_by_advisory_board_date(month, year)
    Transfer::Project.filtered_by_advisory_board_date(month, year)
  end
end
