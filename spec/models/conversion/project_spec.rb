require "rails_helper"

RSpec.describe Conversion::Project do
  describe "relationships" do
    it { is_expected.to have_one(:details).dependent(:destroy) }
  end

  describe "#route" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    context "when the project is a voluntary conversion" do
      let(:project) { create(:voluntary_conversion_project) }

      it "returns the correct route" do
        expect(project.route).to eq :voluntary
      end
    end

    context "when the project is a involuntary conversion" do
      let(:project) { create(:involuntary_conversion_project) }

      it "returns the correct route" do
        expect(project.route).to eq :involuntary
      end
    end
  end
end
