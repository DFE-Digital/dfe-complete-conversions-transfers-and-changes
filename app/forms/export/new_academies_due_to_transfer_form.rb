class Export::NewAcademiesDueToTransferForm < Export::BaseForm
  def export
    projects = Project.not_deleted.transfers.significant_date_in_range(from_date.to_s, to_date.to_s)
    pre_fetched_projects = AcademiesApiPreFetcherService.new.call!(projects)

    Export::Transfers::AcademiesDueToTransferCsvExportService.new(pre_fetched_projects).call
  end
end
