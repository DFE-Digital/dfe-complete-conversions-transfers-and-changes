require "rails_helper"

RSpec.describe ByMonthProjectFetcherService do
  describe "#confirmed" do
    context "with pre fetching disable for this spec" do
      it "sorts the projects by conditions_met? true and then by school name" do
        project_one = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "Y school"))
        project_two = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "B school"))
        project_three = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "A school"))
        project_four = double(Conversion::Project, all_conditions_met?: true, establishment: double("Establishment", name: "Z school"))
        project_five = double(Transfer::Project, all_conditions_met?: false, establishment: double("Establishment", name: "C school"))
        project_six = double(Transfer::Project, all_conditions_met?: false, establishment: double("Establishment", name: "D school"))

        allow(Project).to receive(:filtered_by_significant_date).and_return([project_one, project_two, project_three, project_four, project_five, project_six])

        confirmed_projects = described_class.new(pre_fetch_academies_api: false).confirmed(1, 2025)

        expect(confirmed_projects).to eq [project_four, project_three, project_two, project_five, project_six, project_one]
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, significant_date: Date.parse("2023-1-1"), significant_date_provisional: false)

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

      project = create(:conversion_project, significant_date: Date.parse("2025-6-1"), significant_date_provisional: false)
      create(:date_history, project: project, previous_date: Date.parse("2025-1-1"), revised_date: Date.parse("2025-6-1"))
      create(:date_history, project: project, previous_date: Date.parse("2025-1-1"), revised_date: Date.parse("2025-1-1"))

      other_project = create(:conversion_project, significant_date: Date.parse("2025-6-1"), significant_date_provisional: false)
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

      let!(:project_a) { create(:conversion_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, team: "regional_casework_services") }
      let!(:project_b) { create(:transfer_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, team: "regional_casework_services") }
      let!(:project_c) { create(:conversion_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, region: "london", team: "london") }

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
      create_list(:conversion_project, 21, significant_date: Date.parse("2023-1-1"), significant_date_provisional: false)

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

      let!(:project_a) { create(:conversion_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, team: "regional_casework_services") }
      let!(:project_b) { create(:transfer_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, team: "regional_casework_services") }
      let!(:project_c) { create(:conversion_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, team: "regional_casework_services") }
      let!(:project_d) { create(:conversion_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, region: "london", team: "london") }
      let!(:project_e) { create(:transfer_project, significant_date: Date.new(2023, 1, 1), significant_date_provisional: false, region: "london", team: "london") }

      before do
        create(:date_history, project: project_a, previous_date: Date.new(2023, 1, 1), revised_date: Date.new(2023, 2, 1))
        create(:date_history, project: project_a, previous_date: Date.new(2023, 2, 1), revised_date: Date.new(2023, 3, 1))
        create(:date_history, project: project_b, previous_date: Date.new(2023, 1, 1), revised_date: Date.new(2023, 2, 1))
        create(:date_history, project: project_b, previous_date: Date.new(2023, 2, 1), revised_date: Date.new(2023, 3, 1))
        create(:date_history, project: project_d, previous_date: Date.new(2023, 1, 1), revised_date: Date.new(2023, 2, 1))
        create(:date_history, project: project_d, previous_date: Date.new(2023, 2, 1), revised_date: Date.new(2023, 3, 1))
      end

      context "when the user is in the regional_casework_services team" do
        it "returns only projects where the team is regional_casework_services" do
          projects_fetcher = described_class.new
          expect(projects_fetcher.revised_openers_by_team(2, 2023, user_1.team)).to include(project_a, project_b)
        end
      end

      context "when the user is in a regional team" do
        it "returns only projects where the region matches the user's team" do
          projects_fetcher = described_class.new
          expect(projects_fetcher.revised_openers_by_team(2, 2023, user_2.team)).to eq([project_d])
        end
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, significant_date: Date.parse("2023-1-1"), significant_date_provisional: false)

      academies_api_pre_fetcher = double(call!: true)
      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(academies_api_pre_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.revised_openers_by_team(1, 2023, "regional_casework_services")

      expect(academies_api_pre_fetcher).to have_received(:call!).once
    end
  end

  describe "#conversion_projects_by_date_range" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      it "returns all conversion projects with a confirmed date in the desired range, and orders by significant date" do
        january = Date.parse("2023-1-1")
        february = Date.parse("2023-2-1")
        march = Date.parse("2023-3-1")

        project_1 = create(:conversion_project, significant_date_provisional: false, significant_date: january)
        project_2 = create(:conversion_project, significant_date_provisional: false, significant_date: february)
        project_3 = create(:conversion_project, significant_date_provisional: false, significant_date: march)

        create(:date_history, project: project_1, previous_date: january, revised_date: january)
        create(:date_history, project: project_2, previous_date: february, revised_date: march)
        create(:date_history, project: project_3, previous_date: march, revised_date: march)

        projects_fetcher = described_class.new
        expect(projects_fetcher.conversion_projects_by_date_range("2023-1-1", "2023-3-1")).to eq([project_1, project_2, project_3])
      end
    end
  end

  describe "#transfer_projects_by_date_range" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      it "returns all transfer projects with a confirmed date in the desired range, and orders by significant date" do
        january = Date.parse("2023-1-1")
        february = Date.parse("2023-2-1")
        march = Date.parse("2023-3-1")

        project_1 = create(:transfer_project, significant_date_provisional: false, significant_date: january)
        project_2 = create(:transfer_project, significant_date_provisional: false, significant_date: february)
        project_3 = create(:transfer_project, significant_date_provisional: false, significant_date: march)

        create(:date_history, project: project_1, previous_date: january, revised_date: january)
        create(:date_history, project: project_2, previous_date: february, revised_date: march)
        create(:date_history, project: project_3, previous_date: march, revised_date: march)

        projects_fetcher = described_class.new
        expect(projects_fetcher.transfer_projects_by_date_range("2023-1-1", "2023-3-1")).to eq([project_1, project_2, project_3])
      end
    end
  end

  describe "#conversion_projects_by_date" do
    context "with prefetching disabled for this test" do
      it "returns conversion projects and orders by all conditions met & establishment name" do
        project_one = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "Y school"))
        project_two = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "B school"))
        project_three = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "A school"))
        project_four = double(Conversion::Project, all_conditions_met?: true, establishment: double("Establishment", name: "Z school"))

        allow(Project).to receive(:filtered_by_significant_date).and_return([project_one, project_two, project_three, project_four])
        
        projects = described_class.new(pre_fetch_academies_api: false).conversion_projects_by_date(1, 2025)

        expect(projects).to eq [project_four, project_three, project_two, project_one]
      end
    end
  end
end
