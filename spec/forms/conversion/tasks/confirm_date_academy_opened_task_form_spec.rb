require "rails_helper"

RSpec.describe Conversion::Task::ConfirmDateAcademyOpenedTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  before { mock_all_academies_api_responses }

  def valid_attributes
    date_opened = Date.today - 1.months
    {
      "date_opened(3i)": date_opened.day.to_s,
      "date_opened(2i)": date_opened.month.to_s,
      "date_opened(1i)": date_opened.year.to_s
    }.with_indifferent_access
  end

  describe "validations" do
    describe "date_opened" do
      it "must be a valid date" do
        attributes = valid_attributes
        attributes["date_opened(3i)"] = "31"
        attributes["date_opened(2i)"] = "9"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end

      describe "day parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_opened(3i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_opened(3i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 31" do
          attributes = valid_attributes
          attributes["date_opened(3i)"] = "32"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_opened(3i)"] = "twenty first"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "month parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_opened(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_opened(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 12" do
          attributes = valid_attributes
          attributes["date_opened(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_opened(2i)"] = "January"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year parameters" do
        it "must be a four digit year" do
          attributes = valid_attributes
          attributes["date_opened(1i)"] = "24"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 2000" do
          attributes = valid_attributes
          attributes["date_opened(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 3000" do
          attributes = valid_attributes
          attributes["date_opened(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_opened(1i)"] = "Twenty twenty four"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "saves the task" do
        attributes = valid_attributes
        attributes["date_opened(3i)"] = "1"
        attributes["date_opened(2i)"] = "1"
        attributes["date_opened(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.valid?
        form.save

        expect(project.tasks_data.reload.confirm_date_academy_opened_date_opened).to eq(Date.new(2024, 1, 1))
      end
    end

    context "when the form is invalid" do
      it "shows a helpful error" do
        attributes = valid_attributes
        attributes["date_opened(3i)"] = "1"
        attributes["date_opened(2i)"] = "Jan"
        attributes["date_opened(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.valid?
        form.save

        expect(form.errors.messages_for(:date_opened))
          .to include("Enter a valid date, like 1 2 2024")
      end
    end
  end
end
