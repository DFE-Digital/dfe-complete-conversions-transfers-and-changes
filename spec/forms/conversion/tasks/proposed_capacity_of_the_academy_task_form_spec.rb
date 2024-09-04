require "rails_helper"

RSpec.describe Conversion::Task::ProposedCapacityOfTheAcademyTaskForm do
  before { mock_all_academies_api_responses }

  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  describe "validation" do
    context "when the values are numbers" do
      it "is valid" do
        attributes = {}
        attributes["reception_to_six_years"] = "10"
        attributes["seven_to_eleven_years"] = "20"
        attributes["twelve_or_above_years"] = "30"

        form.assign_attributes(attributes)

        expect(form).to be_valid
      end
    end

    context "when the values are not whole numbers" do
      it "invalid" do
        attributes = {}
        attributes["reception_to_six_years"] = "1.5"
        attributes["seven_to_eleven_years"] = "2.5"
        attributes["twelve_or_above_years"] = "3.5"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end
    end

    context "when the values are not numbers" do
      it "invalid" do
        attributes = {}
        attributes["reception_to_six_years"] = "ten"
        attributes["seven_to_eleven_years"] = "twenty"
        attributes["twelve_or_above_years"] = "thirty"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end
    end

    context "when the values are empty" do
      it "invalid" do
        attributes = {}
        attributes["reception_to_six_years"] = ""
        attributes["seven_to_eleven_years"] = ""
        attributes["twelve_or_above_years"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end
    end
  end
end
