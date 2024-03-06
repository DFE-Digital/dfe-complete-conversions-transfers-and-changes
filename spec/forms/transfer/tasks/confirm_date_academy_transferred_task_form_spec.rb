require "rails_helper"

RSpec.describe Transfer::Task::ConfirmDateAcademyTransferredTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:transfer_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  before { mock_successful_api_response_to_create_any_project }

  describe "validations" do
    describe "day" do
      it "when the value is 3rd, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "1", "date_transferred(3i)": "3rd")

        expect(form).to be_valid
      end

      it "when the value is not in the range of 1..31, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "1", "date_transferred(3i)": "40")

        expect(form).to be_invalid
      end

      it "when the value is not a number, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "1", "date_transferred(3i)": "not a number")

        expect(form).to be_invalid
      end
    end

    describe "month" do
      it "when the value is not in the range of 1..12, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "20", "date_transferred(3i)": "20")

        expect(form).to be_invalid
      end

      it "when the value is not a number, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "January", "date_transferred(3i)": "20")

        expect(form).to be_invalid
      end
    end

    describe "year" do
      it "when the value is not in the range of 1900..3000, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "800", "date_transferred(2i)": "2", "date_transferred(3i)": "20")

        expect(form).to be_invalid
      end

      it "when the value is not a number, it is invalid" do
        form.assign_attributes("date_transferred(1i)": "Nineteen hundred", "date_transferred(2i)": "1", "date_transferred(3i)": "20")

        expect(form).to be_invalid
      end
    end

    describe "the transfer to a date" do
      context "when the values form a date that is incorrect" do
        it "is invalid" do
          form.assign_attributes("date_transferred(1i)": "30", "date_transferred(2i)": "2", "date_transferred(3i)": "2024")

          expect(form).to be_invalid
        end
      end
    end

    describe "submitting nothing" do
      it "when a user submits nothing, its valid" do
        form.assign_attributes("date_transferred(1i)": "", "date_transferred(2i)": "", "date_transferred(3i)": "")

        expect(form).to be_valid
      end

      it "when a user submits spaces, its valid" do
        form.assign_attributes("date_transferred(1i)": "  ", "date_transferred(2i)": "  ", "date_transferred(3i)": "   ")

        expect(form).to be_valid
      end
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "saves the task" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "1", "date_transferred(3i)": "1")

        form.save

        expect(project.tasks_data.reload.confirm_date_academy_transferred_date_transferred).to eq(Date.new(2024, 1, 1))
      end
    end

    context "when the form is invalid" do
      it "shows the error" do
        form.assign_attributes("date_transferred(1i)": "2024", "date_transferred(2i)": "January", "date_transferred(3i)": "4")

        form.save

        expect(form.errors.messages[:date_transferred])
          .to include(I18n.t("transfer.task.confirm_date_academy_transferred.errors.format"))
      end
    end
  end
end
