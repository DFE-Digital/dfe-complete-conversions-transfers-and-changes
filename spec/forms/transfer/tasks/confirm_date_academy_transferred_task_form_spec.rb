require "rails_helper"

RSpec.describe Transfer::Task::ConfirmDateAcademyTransferredTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:transfer_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  before { mock_successful_api_response_to_create_any_project }

  def valid_attributes
    date_transferred = Date.today - 1.months
    {
      "date_transferred(3i)": date_transferred.day.to_s,
      "date_transferred(2i)": date_transferred.month.to_s,
      "date_transferred(1i)": date_transferred.year.to_s
    }.with_indifferent_access
  end

  describe "validations" do
    describe "date_transferred" do
      describe "day parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_transferred(3i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_transferred(3i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 31" do
          attributes = valid_attributes
          attributes["date_transferred(3i)"] = "32"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_transferred(3i)"] = "twenty first"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "month parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_transferred(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_transferred(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 12" do
          attributes = valid_attributes
          attributes["date_transferred(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_transferred(2i)"] = "January"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year parameters" do
        it "must be a four digit year" do
          attributes = valid_attributes
          attributes["date_transferred(1i)"] = "24"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 2000" do
          attributes = valid_attributes
          attributes["date_transferred(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 3000" do
          attributes = valid_attributes
          attributes["date_transferred(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_transferred(1i)"] = "Twenty twenty four"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      it "can be empty" do
        attributes = valid_attributes
        attributes["date_transferred(3i)"] = ""
        attributes["date_transferred(2i)"] = ""
        attributes["date_transferred(1i)"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_valid
      end
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "saves the task" do
        attributes = valid_attributes
        attributes["date_transferred(3i)"] = "1"
        attributes["date_transferred(2i)"] = "1"
        attributes["date_transferred(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.save

        expect(project.tasks_data.reload.confirm_date_academy_transferred_date_transferred).to eq(Date.new(2024, 1, 1))
      end
    end

    context "when the form is invalid" do
      it "shows a helpful message" do
        attributes = valid_attributes
        attributes["date_transferred(3i)"] = "1"
        attributes["date_transferred(2i)"] = "January"
        attributes["date_transferred(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.save

        expect(form.errors.messages[:date_transferred])
          .to include("Enter a valid date, like 1 1 2025")
      end
    end
  end
end
