require "rails_helper"

RSpec.describe Conversion::Project do
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

  describe "#conversion_date" do
    context "when the project is an involuntary conversion" do
      let(:project) { build(:involuntary_conversion_project) }

      context "when the project has no confirmed conversion date" do
        it "returns the appropriate values" do
          conversion_date = project.conversion_date

          expect(conversion_date.date).to eq project.provisional_conversion_date
          expect(conversion_date.provisional?).to eq true
        end
      end

      context "when the project has a confirmed conversion date from the external stakeholder kick off task" do
        it "returns the appropriate values" do
          project.task_list.stakeholder_kick_off_confirmed_conversion_date = Date.today + 1.year
          conversion_date = project.conversion_date

          expect(conversion_date.date).to eq project.task_list.stakeholder_kick_off_confirmed_conversion_date
          expect(conversion_date.provisional?).to eq false
        end
      end
    end

    context "when the project has no confirmed conversion date" do
      let(:project) { build(:voluntary_conversion_project) }

      context "when the project has no confirmed conversion date" do
        it "returns the appropriate values" do
          conversion_date = project.conversion_date

          expect(conversion_date.date).to eq project.provisional_conversion_date
          expect(conversion_date.provisional?).to eq true
        end
      end

      context "when the project has a confirmed conversion date from the external stakeholder kick off task" do
        it "returns the appropriate values" do
          project.task_list.stakeholder_kick_off_confirmed_conversion_date = Date.today + 1.year
          conversion_date = project.conversion_date

          expect(conversion_date.date).to eq project.task_list.stakeholder_kick_off_confirmed_conversion_date
          expect(conversion_date.provisional?).to eq false
        end
      end
    end

    context "when the project has a confirmed conversion date from the external stakeholder kick off task" do
      let(:project) { build(:voluntary_conversion_project) }

      it "returns the appropriate values" do
        project.task_list.stakeholder_kick_off_confirmed_conversion_date = Date.today + 1.year
        conversion_date = project.conversion_date

        expect(conversion_date.date).to eq project.task_list.stakeholder_kick_off_confirmed_conversion_date
        expect(conversion_date.provisional?).to eq false
      end
    end
  end
end
