require "rails_helper"

RSpec.describe ProjectsForExportService do
  before do
    mock_academies_api_client_get_establishments_and_trusts
  end

  describe "#grant_management_and_finance_unit_conversion_projects" do
    it "returns only conversion projects with an advisory board date of the supplied month and year" do
      matching_project = create(:conversion_project, conversion_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))
      mismatching_project = create(:conversion_project, conversion_date_provisional: false, advisory_board_date: Date.parse("2023-2-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_conversion_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(matching_project)
      expect(projects_for_export).not_to include(mismatching_project)
    end

    it "includes both provisional and confirmed projects" do
      mock_academies_api_client_get_establishments_and_trusts

      confirmed_project = create(:conversion_project, conversion_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))
      provisional_project = create(:conversion_project, conversion_date_provisional: true, advisory_board_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_conversion_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(confirmed_project)
      expect(projects_for_export).to include(provisional_project)
    end

    it "includes Form a MAT conversions" do
      project = create(:conversion_project, :form_a_mat, conversion_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_conversion_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(project)
    end

    it "does not include deleted projects" do
      project = create(:conversion_project, :deleted, conversion_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_conversion_projects(month: 1, year: 2023)

      expect(projects_for_export).to_not include(project)
    end
  end

  describe "#grant_management_and_finance_unit_transfer_projects" do
    it "returns only transfer projects with an advisory board date of the supplied month and year" do
      matching_project = create(:transfer_project, significant_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))
      mismatching_project_1 = create(:conversion_project, significant_date_provisional: false, advisory_board_date: Date.parse("2023-2-1"))
      mismatching_project_2 = create(:transfer_project, significant_date_provisional: false, advisory_board_date: Date.parse("2023-2-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_transfer_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(matching_project)
      expect(projects_for_export).not_to include(mismatching_project_1, mismatching_project_2)
    end

    it "includes both provisional and confirmed projects" do
      confirmed_project = create(:transfer_project, transfer_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))
      provisional_project = create(:transfer_project, transfer_date_provisional: true, advisory_board_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_transfer_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(confirmed_project)
      expect(projects_for_export).to include(provisional_project)
    end

    it "includes Form a MAT transfers" do
      project = create(:transfer_project, :form_a_mat, significant_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_transfer_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(project)
    end

    it "does not include deleted projects" do
      project = create(:transfer_project, :deleted, significant_date_provisional: false, advisory_board_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.grant_management_and_finance_unit_transfer_projects(month: 1, year: 2023)

      expect(projects_for_export).to_not include(project)
    end
  end

  describe "#transfer_by_month_projects" do
    it "returns only transfer projects transferring in the supplied month & year" do
      matching_project_1 = create(:transfer_project, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))
      matching_project_2 = create(:transfer_project, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))
      mismatching_project_1 = create(:transfer_project, significant_date_provisional: false, significant_date: Date.parse("2023-2-1"))
      mismatching_project_2 = create(:conversion_project, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.transfer_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(matching_project_1, matching_project_2)
      expect(projects_for_export).not_to include(mismatching_project_1, mismatching_project_2)
    end

    it "includes both provisional and confirmed projects" do
      confirmed_project = create(:transfer_project, transfer_date_provisional: false, significant_date: Date.parse("2023-1-1"))
      provisional_project = create(:transfer_project, transfer_date_provisional: true, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.transfer_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(confirmed_project)
      expect(projects_for_export).to include(provisional_project)
    end

    it "includes Form a MAT transfers" do
      project = create(:transfer_project, :form_a_mat, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.transfer_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(project)
    end

    it "does not include deleted projects" do
      project = create(:transfer_project, :deleted, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.transfer_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to_not include(project)
    end
  end

  describe "#conversion_by_month_projects" do
    it "returns only conversion projects converting in the supplied month & year" do
      matching_project_1 = create(:conversion_project, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))
      matching_project_2 = create(:conversion_project, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))
      mismatching_project_1 = create(:conversion_project, significant_date_provisional: false, significant_date: Date.parse("2023-2-1"))
      mismatching_project_2 = create(:transfer_project, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.conversion_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(matching_project_1, matching_project_2)
      expect(projects_for_export).not_to include(mismatching_project_1, mismatching_project_2)
    end

    it "includes both provisional and confirmed projects" do
      confirmed_project = create(:conversion_project, conversion_date_provisional: false, significant_date: Date.parse("2023-1-1"))
      provisional_project = create(:conversion_project, conversion_date_provisional: true, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.conversion_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(confirmed_project)
      expect(projects_for_export).to include(provisional_project)
    end

    it "includes Form a MAT conversions" do
      project = create(:conversion_project, :form_a_mat, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.conversion_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to include(project)
    end

    it "does not include deleted projects" do
      project = create(:conversion_project, :deleted, significant_date_provisional: false, significant_date: Date.parse("2023-1-1"))

      projects_for_export = described_class.new.conversion_by_month_projects(month: 1, year: 2023)

      expect(projects_for_export).to_not include(project)
    end
  end

  def mock_academies_api_client_get_establishments_and_trusts
    api_client = Api::AcademiesApi::Client.new
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new([double("Trust", ukprn: true)], nil))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double("Trust"), nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double("Establishment"), nil))

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
    allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([double("Establishment", urn: true)], nil))

    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double("Establishment"), nil))
    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double("Trust"), nil))
    api_client
  end
end
