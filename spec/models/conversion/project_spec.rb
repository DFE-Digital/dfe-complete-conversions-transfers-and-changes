require "rails_helper"

RSpec.describe Conversion::Project do
  describe "#route" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    context "when the project is a voluntary conversion" do
      let(:project) { create(:conversion_project, sponsor_trust_required: false) }

      it "returns the correct route" do
        expect(project.route).to eq :voluntary
      end
    end

    context "when the project is a sponsored conversion" do
      let(:project) { create(:conversion_project, sponsor_trust_required: true) }

      it "returns the correct route" do
        expect(project.route).to eq :sponsored
      end
    end
  end
end
