require "rails_helper"

RSpec.describe ByMonthProjectFetcherService do
  describe "#confirmed" do
    context "with pre fetching disable for this spec" do
      it "sorts the projects by conditions_met? true and then by school name" do
        project_one = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "Y school"))
        project_two = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "B school"))
        project_three = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "A school"))
        project_four = double(Conversion::Project, all_conditions_met?: true, establishment: double("Establishment", name: "Z school"))

        allow(Project).to receive(:filtered_by_significant_date).and_return([project_one, project_two, project_three, project_four])

        confirmed_projects = described_class.new(pre_fetch_academies_api: false).confirmed(1, 2025)

        expect(confirmed_projects.first).to eq project_four
        expect(confirmed_projects.last).to eq project_one
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional: false)

      academies_api_pre_fetcher = double(call!: true)
      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(academies_api_pre_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.confirmed(1, 2023)

      expect(academies_api_pre_fetcher).to have_received(:call!).once
    end
  end

  describe "#revised" do
    it "returns only the projects where the date was the given month but has since changed" do
      mock_all_academies_api_responses

      project = create(:conversion_project, conversion_date: Date.parse("2025-6-1"), conversion_date_provisional: false)
      create(:date_history, project: project, previous_date: Date.parse("2025-1-1"), revised_date: Date.parse("2025-6-1"))
      create(:date_history, project: project, previous_date: Date.parse("2025-1-1"), revised_date: Date.parse("2025-1-1"))

      other_project = create(:conversion_project, conversion_date: Date.parse("2025-6-1"), conversion_date_provisional: false)
      create(:date_history, project: project, previous_date: Date.parse("2025-1-1"), revised_date: Date.parse("2025-6-1"))

      projects = described_class.new.revised(1, 2025)

      expect(projects).to include project
      expect(projects).not_to include other_project
    end
  end

  describe "#confirmed_openers_by_team" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      let(:user_1) { create(:regional_casework_services_user, team: "regional_casework_services") }
      let(:user_2) { create(:regional_delivery_officer_user, team: "london") }

      let!(:project_a) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, team: "regional_casework_services") }
      let!(:project_b) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, team: "regional_casework_services") }
      let!(:project_c) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, region: "london", team: "london") }

      context "when the user is in the regional_casework_services team" do
        it "returns only projects where the team is regional_casework_services" do
          projects_fetcher = described_class.new
          expect(projects_fetcher.confirmed_openers_by_team(1, 2023, user_1.team)).to include(project_a, project_b)
        end
      end

      context "when the user is in a regional team" do
        it "returns only projects where the region matches the user's team" do
          projects_fetcher = described_class.new
          expect(projects_fetcher.confirmed_openers_by_team(1, 2023, user_2.team)).to include(project_c)
        end
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional: false)

      academies_api_pre_fetcher = double(call!: true)
      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(academies_api_pre_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.confirmed_openers_by_team(1, 2023, "regional_casework_services")

      expect(academies_api_pre_fetcher).to have_received(:call!).once
    end
  end

  describe "#revised_openers_by_team" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      let(:user_1) { create(:regional_casework_services_user, team: "regional_casework_services") }
      let(:user_2) { create(:regional_delivery_officer_user, team: "london") }

      let!(:project_a) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, team: "regional_casework_services") }
      let!(:project_b) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, team: "regional_casework_services") }
      let!(:project_c) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, region: "london", team: "london") }

      before do
        create(:date_history, project: project_a, previous_date: Date.new(2023, 1, 1), revised_date: Date.new(2023, 2, 1))
        create(:date_history, project: project_a, previous_date: Date.new(2023, 2, 1), revised_date: Date.new(2023, 3, 1))
        create(:date_history, project: project_c, previous_date: Date.new(2023, 1, 1), revised_date: Date.new(2023, 2, 1))
        create(:date_history, project: project_c, previous_date: Date.new(2023, 2, 1), revised_date: Date.new(2023, 3, 1))
      end

      context "when the user is in the regional_casework_services team" do
        it "returns only projects where the team is regional_casework_services" do
          projects_fetcher = described_class.new
          expect(projects_fetcher.revised_openers_by_team(2, 2023, user_1.team)).to eq([project_a])
        end
      end

      context "when the user is in a regional team" do
        it "returns only projects where the region matches the user's team" do
          projects_fetcher = described_class.new
          expect(projects_fetcher.revised_openers_by_team(2, 2023, user_2.team)).to eq([project_c])
        end
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional: false)

      academies_api_pre_fetcher = double(call!: true)
      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(academies_api_pre_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.revised_openers_by_team(1, 2023, "regional_casework_services")

      expect(academies_api_pre_fetcher).to have_received(:call!).once
    end
  end
end
