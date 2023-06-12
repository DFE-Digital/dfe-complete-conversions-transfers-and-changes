require "rails_helper"

RSpec.describe ConversionProjectsFetcher do
  let(:projects_fetcher) { described_class.new }

  describe "#sorted_openers" do
    let(:establishment_a) { double(name: "A School") }
    let(:establishment_b) { double(name: "B School") }
    let(:establishment_c) { double(name: "C School") }
    let(:establishment_d) { double(name: "D School") }
    let(:project_a) { double(all_conditions_met?: true, establishment: establishment_a) }
    let(:project_b) { double(all_conditions_met?: false, establishment: establishment_b) }
    let(:project_c) { double(all_conditions_met?: true, establishment: establishment_c) }
    let(:project_d) { double(all_conditions_met?: false, establishment: establishment_d) }
    let(:projects) { [project_d, project_b, project_a, project_c] }

    before do
      allow(Conversion::Project).to receive(:opening_by_month_year).and_return(projects)
    end

    it "sorts the projects by conditions_met? true and then by school name" do
      expected_result = [project_a, project_c, project_b, project_d]
      expect(projects_fetcher.sorted_openers(1, 2023)).to eq expected_result
    end
  end
end
