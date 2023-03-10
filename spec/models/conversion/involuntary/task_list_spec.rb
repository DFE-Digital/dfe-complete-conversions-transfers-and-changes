require "rails_helper"

RSpec.describe Conversion::Involuntary::TaskList do
  let(:task_class) { Conversion::Involuntary::Tasks::Handover }
  let(:task_list) {
    Conversion::Involuntary::TaskList.create!(
      handover_review: true
    )
  }

  it_behaves_like "a task list"

  describe "#locales_path" do
    it "returns the appropriate locales path based on the class path" do
      expect(task_list.locales_path).to eq "conversion.involuntary.task_list"
    end
  end

  describe "conversion date" do
    context "when the projects task list is saved" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "syncs the conversion date with the project" do
        project = create(:involuntary_conversion_project, conversion_date: Date.today.at_beginning_of_month - 6.months, conversion_date_provisional: true)

        project.task_list.update(stakeholder_kick_off_confirmed_conversion_date: Date.today.at_beginning_of_month)

        expect(project.reload.conversion_date).to eq Date.today.at_beginning_of_month
        expect(project.reload.conversion_date_provisional).to eq false
      end

      it "can only sync once" do
        project = create(:involuntary_conversion_project, conversion_date: Date.today.at_beginning_of_month - 6.months, conversion_date_provisional: false)

        project.task_list.update(stakeholder_kick_off_confirmed_conversion_date: Date.tomorrow.at_beginning_of_month)

        expect(project.reload.conversion_date).to eq Date.today.at_beginning_of_month - 6.months
      end
    end
  end
end
