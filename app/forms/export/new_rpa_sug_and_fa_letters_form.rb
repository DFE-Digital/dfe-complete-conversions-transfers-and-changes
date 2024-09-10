class Export::NewRpaSugAndFaLettersForm < Export::BaseForm
  def export
    projects = Project.not_deleted.not_dao_revoked.conversions.significant_date_in_range(from_date, to_date)
    pre_fetched_projects = AcademiesApiPreFetcherService.new.call!(projects)

    Export::Conversions::RpaSugAndFaLettersCsvExportService.new(pre_fetched_projects).call
  end
end
