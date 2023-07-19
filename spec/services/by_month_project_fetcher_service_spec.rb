require "rails_helper"

RSpec.describe ByMonthProjectFetcherService do
  describe "#sorted_openers" do
    context "with pre fetching disabled for this test" do
      before do
        allow(Conversion::Project).to receive(:opening_by_month_year).and_return(projects)
      end

      let(:establishment_a) { double(name: "A School") }
      let(:establishment_b) { double(name: "B School") }
      let(:establishment_c) { double(name: "C School") }
      let(:establishment_d) { double(name: "D School") }
      let(:project_a) { double(all_conditions_met?: true, establishment: establishment_a) }
      let(:project_b) { double(all_conditions_met?: false, establishment: establishment_b) }
      let(:project_c) { double(all_conditions_met?: true, establishment: establishment_c) }
      let(:project_d) { double(all_conditions_met?: false, establishment: establishment_d) }
      let(:projects) { [project_d, project_b, project_a, project_c] }

      it "sorts the projects by conditions_met? true and then by school name" do
        projects_fetcher = described_class.new(prefetch: false)
        expected_result = [project_a, project_c, project_b, project_d]
        expect(projects_fetcher.sorted_openers(1, 2023)).to eq expected_result
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional: false)

      establishments_fetcher = double(batched!: true)
      allow(EstablishmentsFetcherService).to receive(:new).and_return(establishments_fetcher)

      trusts_fetcher = double(batched!: true)
      allow(TrustsFetcherService).to receive(:new).and_return(trusts_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.sorted_openers(1, 2023)

      expect(establishments_fetcher).to have_received(:batched!)
      expect(trusts_fetcher).to have_received(:batched!)
    end
  end

  describe "#confirmed_openers_by_team" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      let(:user_1) { create(:user, :caseworker, team: "regional_casework_services") }
      let(:user_2) { create(:user, :caseworker, team: "london") }

      let!(:project_a) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, team: "regional_casework_services") }
      let!(:project_b) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, team: "regional_casework_services") }
      let!(:project_c) { create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, region: "london", team: "london") }

      context "when the user is in the regional_casework_services team" do
        it "returns only projects where the team is regional_casework_services" do
          projects_fetcher = described_class.new(prefetch: false)
          expect(projects_fetcher.confirmed_openers_by_team(1, 2023, user_1.team)).to include(project_a, project_b)
        end
      end

      context "when the user is in a regional team" do
        it "returns only projects where the region matches the user's team" do
          projects_fetcher = described_class.new(prefetch: false)
          expect(projects_fetcher.confirmed_openers_by_team(1, 2023, user_2.team)).to include(project_c)
        end
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional: false)

      establishments_fetcher = double(batched!: true)
      allow(EstablishmentsFetcherService).to receive(:new).and_return(establishments_fetcher)

      trusts_fetcher = double(batched!: true)
      allow(TrustsFetcherService).to receive(:new).and_return(trusts_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.confirmed_openers_by_team(1, 2023, "regional_casework_services")

      expect(establishments_fetcher).to have_received(:batched!)
      expect(trusts_fetcher).to have_received(:batched!)
    end
  end

  describe "#revised_openers_by_team" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      let(:user_1) { create(:user, :caseworker, team: "regional_casework_services") }
      let(:user_2) { create(:user, :caseworker, team: "london") }

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
          projects_fetcher = described_class.new(prefetch: false)
          expect(projects_fetcher.revised_openers_by_team(2, 2023, user_1.team)).to eq([project_a])
        end
      end

      context "when the user is in a regional team" do
        it "returns only projects where the region matches the user's team" do
          projects_fetcher = described_class.new(prefetch: false)
          expect(projects_fetcher.revised_openers_by_team(2, 2023, user_2.team)).to eq([project_c])
        end
      end
    end

    it "prefetches establishments and trusts by default" do
      mock_all_academies_api_responses
      create_list(:conversion_project, 21, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional: false)

      establishments_fetcher = double(batched!: true)
      allow(EstablishmentsFetcherService).to receive(:new).and_return(establishments_fetcher)

      trusts_fetcher = double(batched!: true)
      allow(TrustsFetcherService).to receive(:new).and_return(trusts_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.revised_openers_by_team(1, 2023, "regional_casework_services")

      expect(establishments_fetcher).to have_received(:batched!)
      expect(trusts_fetcher).to have_received(:batched!)
    end
  end
end
