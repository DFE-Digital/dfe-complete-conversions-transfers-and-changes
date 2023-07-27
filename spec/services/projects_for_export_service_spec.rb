require "rails_helper"

RSpec.describe ProjectsForExportService do
  describe "#risk_protection_arrangement_projects" do
    it "returns only conversion projects" do
      mock_academies_api_client_get_establishments_and_trusts

      transfer_project = create(:transfer_project, transfer_date_provisional: false, transfer_date: Date.parse("2025-1-1"))
      conversion_project = create(:conversion_project, conversion_date_provisional: false, conversion_date: Date.parse("2025-1-1"))

      projects_for_export = described_class.new.risk_protection_arrangement_projects(month: 1, year: 2025)

      expect(projects_for_export).to include(conversion_project)
      expect(projects_for_export).not_to include(transfer_project)
    end

    it "returns only confirmed projects" do
      mock_academies_api_client_get_establishments_and_trusts

      confirmed_project = create(:conversion_project, conversion_date_provisional: false, conversion_date: Date.parse("2025-1-1"))
      unconfirmed_project = create(:conversion_project, conversion_date_provisional: true, conversion_date: Date.parse("2025-1-1"))

      projects_for_export = described_class.new.risk_protection_arrangement_projects(month: 1, year: 2025)

      expect(projects_for_export).to include(confirmed_project)
      expect(projects_for_export).not_to include(unconfirmed_project)
    end

    it "returns only projects opening on the supplied month and year" do
      mock_academies_api_client_get_establishments_and_trusts

      matching_project = create(:conversion_project, conversion_date_provisional: false, conversion_date: Date.parse("2025-1-1"))
      mismatching_project = create(:conversion_project, conversion_date_provisional: false, conversion_date: Date.parse("2026-2-1"))

      projects_for_export = described_class.new.risk_protection_arrangement_projects(month: 1, year: 2025)

      expect(projects_for_export).to include(matching_project)
      expect(projects_for_export).not_to include(mismatching_project)
    end

    it "prefetches entities" do
      mock_academies_api_client_get_establishments_and_trusts

      create(:conversion_project, conversion_date_provisional: false, conversion_date: Date.parse("2025-1-1"))

      projects_for_export = described_class.new.risk_protection_arrangement_projects(month: 1, year: 2025)

      expect(projects_for_export.first.establishment).not_to be_nil
      expect(projects_for_export.first.incoming_trust).not_to be_nil
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
