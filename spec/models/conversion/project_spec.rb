require "rails_helper"

RSpec.describe Conversion::Project do
  describe "#route" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    context "when a directive academy order has been issued" do
      context "and the school is joining a sponsor trust" do
        let(:project) { create(:conversion_project, directive_academy_order: true) }

        it "the route is sponsored" do
          expect(project.route).to eq :sponsored
        end
      end
    end

    context "when the project has not been issued a directive academy order" do
      context "and the school is joining a sponsor trust" do
        let(:project) { create(:conversion_project, directive_academy_order: false) }

        it "the route is voluntary" do
          expect(project.route).to eq :voluntary
        end
      end

      context "and the school is not joining a sponsor trust" do
        let(:project) { create(:conversion_project, directive_academy_order: false) }

        it "the route is voluntary" do
          expect(project.route).to eq :voluntary
        end
      end
    end
  end
end
