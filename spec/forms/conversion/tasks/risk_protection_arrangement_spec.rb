require "rails_helper"

RSpec.describe Conversion::Task::RiskProtectionArrangementTaskForm do
  describe "validations" do
    describe "option" do
      it "must be one of the expected values" do
        user = build(:user)
        task_form = described_class.new(Conversion::TasksData.new, user)
        task_form.assign_attributes(
          option: "not_expected"
        )

        expect(task_form).to be_invalid

        task_form.assign_attributes(
          option: "standard"
        )

        expect(task_form).to be_valid
      end
    end
  end
end
