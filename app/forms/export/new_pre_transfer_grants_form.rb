class Export::NewPreTransferGrantsForm < Export::BaseForm
  def export
    projects = Project.transfers.advisory_board_date_in_range(from_date.to_s, to_date.to_s)
    pre_fetched_projects = AcademiesApiPreFetcherService.new.call!(projects)

    Export::Transfers::GrantManagementAndFinanceUnitCsvExportService.new(pre_fetched_projects).call
  end
end
