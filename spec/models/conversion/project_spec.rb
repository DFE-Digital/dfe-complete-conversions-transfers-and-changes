require "rails_helper"

RSpec.describe Conversion::Project do
  before { mock_successful_api_response_to_create_any_project }

  describe "#route" do
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

  describe "#fetch_provisional_conversion_date" do
    context "when there are no conversion date histories" do
      it "returns the value in conversion_date" do
        project = build(:conversion_project, conversion_date: Date.today)

        expect(project.fetch_provisional_conversion_date).to eql Date.today
      end
    end

    context "whent here are conversion date histories" do
      context "when here are conversion date histories" do
        it "returns the previous value from the earliest conversion date history" do
          project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
          first_date_history = create(:date_history, project: project, previous_date: Date.today.at_beginning_of_month + 2.months)
          _second_date_history = create(:date_history, project: project, previous_date: Date.today.at_beginning_of_month + 4.months)

          expect(project.fetch_provisional_conversion_date).to eql first_date_history.previous_date
        end
      end
    end
  end
end
