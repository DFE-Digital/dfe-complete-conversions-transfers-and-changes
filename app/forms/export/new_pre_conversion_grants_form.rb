class Export::NewPreConversionGrantsForm < Export::BaseForm
  def export
    projects = Project.not_deleted.conversions.advisory_board_date_in_range(from_date, to_date)

    pre_fetched_projects = AcademiesApiPreFetcherService.new.call!(projects)

    Export::Conversions::PreConversionGrantsCsvExportService.new(pre_fetched_projects).call
  end
end
