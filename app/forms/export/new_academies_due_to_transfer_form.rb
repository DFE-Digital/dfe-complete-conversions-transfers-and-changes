class Export::NewAcademiesDueToTransferForm < Export::BaseForm
  def export
    projects = Project.not_deleted.not_inactive.transfers.significant_date_in_range(from_date, to_date)
    pre_fetched_projects = AcademiesApiPreFetcherService.new.call!(projects)

    Export::Transfers::AcademiesDueToTransferCsvExportService.new(pre_fetched_projects).call
  end
end
