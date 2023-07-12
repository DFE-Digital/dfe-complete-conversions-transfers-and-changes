require "rails_helper"

RSpec.describe Export::RiskProtectionArrangementCsvExportService do
  describe "#call" do
    it "returns only the headers when there are no projects" do
      projects = []

      csv_export = described_class.new(projects).call

      expect(csv_export).to include("School URN")
      expect(csv_export).to include("Assigned to email")
    end

    it "returns a row of data" do
      mock_all_academies_api_responses
      project = build(:conversion_project)
      projects = [project]

      csv_export = described_class.new(projects).call

      expect(csv_export).to include(project.establishment.name)
      expect(csv_export).to include(project.assigned_to.email)
    end
  end

  describe Export::RiskProtectionArrangementCsvExportService::ConversionProjectCsvPresenter do
    it "presents the school urn" do
      project = double(Conversion::Project, urn: 123456)

      presenter = described_class.new(project)

      expect(presenter.school_urn).to eql "123456"
    end

    it "presents the school name" do
      establishment = double(Api::AcademiesApi::Establishment, name: "School Name")
      project = double(Conversion::Project, establishment: establishment)

      presenter = described_class.new(project)

      expect(presenter.school_name).to eql "School Name"
    end

    it "presents the academy urn" do
      project = double(Conversion::Project, academy_urn: 165432)

      presenter = described_class.new(project)

      expect(presenter.academy_urn).to eql "165432"
    end

    it "presents the academy name" do
      establishment = double(Api::AcademiesApi::Establishment, name: "Academy Name")
      project = double(Conversion::Project, academy: establishment, academy_urn: 165432)

      presenter = described_class.new(project)

      expect(presenter.academy_name).to eql "Academy Name"
    end

    it "presents unconfirmed when the academy name and urn has yet to be confirmed" do
      project = double(Conversion::Project, academy: nil, academy_urn: nil)

      presenter = described_class.new(project)

      expect(presenter.academy_name).to eql "unconfirmed"
    end

    it "presents the trust identifier" do
      trust = double(Api::AcademiesApi::Trust, group_identifier: "TR123123")
      project = double(Conversion::Project, incoming_trust: trust)

      presenter = described_class.new(project)

      expect(presenter.trust_identifier).to eql "TR123123"
    end

    it "presents the trust companies house number" do
      trust = double(Api::AcademiesApi::Trust, companies_house_number: 123123)
      project = double(Conversion::Project, incoming_trust: trust)

      presenter = described_class.new(project)

      expect(presenter.trust_companies_house_number).to eql "123123"
    end

    it "presents the trust name" do
      trust = double(Api::AcademiesApi::Trust, name: "Trust name")
      project = double(Conversion::Project, incoming_trust: trust)

      presenter = described_class.new(project)

      expect(presenter.trust_name).to eql "Trust name"
    end

    it "presents the conversion date" do
      project = double(Conversion::Project, conversion_date: Date.parse("2023-1-1"))

      presenter = described_class.new(project)

      expect(presenter.conversion_date).to eql "2023-01-01"
    end

    it "presents all conditions met" do
      tasks_data = double(Conversion::TasksData, conditions_met_confirm_all_conditions_met: true)
      project = double(Conversion::Project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.all_conditions_met).to eql "yes"
    end

    it "presents all conditions met when it has not been met" do
      tasks_data = double(Conversion::TasksData, conditions_met_confirm_all_conditions_met: nil)
      project = double(Conversion::Project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.all_conditions_met).to eql "no"
    end

    it "presents all risk protection arrangement when it is standard" do
      tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: :standard)
      project = double(Conversion::Project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.risk_protection_arrangement).to eql "standard"
    end

    it "presents all risk protection arrangement when it is church/trust" do
      tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: :church_or_trust)
      project = double(Conversion::Project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.risk_protection_arrangement).to eql "church or trust"
    end

    it "presents all risk protection arrangement when it is commercial" do
      tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: :commercial)
      project = double(Conversion::Project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.risk_protection_arrangement).to eql "commercial"
    end

    it "presents the assigned to name" do
      user = double(User, full_name: "Assigned User")
      project = double(Conversion::Project, assigned_to: user)

      presenter = described_class.new(project)

      expect(presenter.assigned_to_name).to eql "Assigned User"
    end

    it "presents the assigned to email" do
      user = double(User, email: "assigned.user@education.gov.uk")
      project = double(Conversion::Project, assigned_to: user)

      presenter = described_class.new(project)

      expect(presenter.assigned_to_email).to eql "assigned.user@education.gov.uk"
    end
  end
end
