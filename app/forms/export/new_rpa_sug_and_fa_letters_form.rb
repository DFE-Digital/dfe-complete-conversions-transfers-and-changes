class Export::NewRpaSugAndFaLettersForm < Export::BaseForm
  def export
    projects = Project.conversions.significant_date_in_range(from_date.to_s, to_date.to_s)
    pre_fetched_projects = AcademiesApiPreFetcherService.new.call!(projects)

    Export::Conversions::RpaSugAndFaLettersCsvExportService.new(pre_fetched_projects).call
  end
end
