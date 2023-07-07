require "rails_helper"

RSpec.describe ConversionProjectsFetcherService do
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

      establishments_fetcher = double(call!: true)
      allow(EstablishmentsFetcherService).to receive(:new).and_return(establishments_fetcher)

      trusts_fetcher = double(call!: true)
      allow(TrustsFetcherService).to receive(:new).and_return(trusts_fetcher)

      projects_fetcher = described_class.new
      projects_fetcher.sorted_openers(1, 2023)

      expect(establishments_fetcher).to have_received(:call!)
      expect(trusts_fetcher).to have_received(:call!)
    end
  end
end
