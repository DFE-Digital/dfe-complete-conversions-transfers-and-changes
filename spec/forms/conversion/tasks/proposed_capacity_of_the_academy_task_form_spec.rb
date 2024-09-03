require "rails_helper"

RSpec.describe Conversion::Task::ProposedCapacityOfTheAcademyTaskForm do
  describe "validations" do
    describe "pupil capacities" do
      it "must be numbers" do
        user = build(:user)
        task_form = described_class.new(Conversion::TasksData.new, user)
        task_form.assign_attributes(
          reception_to_six_years: "100",
          seven_to_eleven_years: "200",
          twelve_or_above_years: "300"
        )

        expect(task_form).to be_valid
      end

      it "cannot be numbers in words" do
        user = build(:user)
        task_form = described_class.new(Conversion::TasksData.new, user)
        task_form.assign_attributes(
          reception_to_six_years: "one hundred",
          seven_to_eleven_years: "two hundred",
          twelve_or_above_years: "three hundred"
        )

        expect(task_form).to be_invalid
      end

      it "cannot be blank" do
        user = build(:user)
        task_form = described_class.new(Conversion::TasksData.new, user)
        task_form.assign_attributes(
          reception_to_six_years: "",
          seven_to_eleven_years: "",
          twelve_or_above_years: ""
        )

        expect(task_form).to be_invalid
      end
    end
  end
end
