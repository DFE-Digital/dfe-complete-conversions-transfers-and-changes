require "rails_helper"

RSpec.describe Transfer::Task::DeclarationOfExpenditureCertificateTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:transfer_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  before { mock_successful_api_response_to_create_any_project }

  def valid_attributes
    date_received = Date.today - 1.months
    {
      "date_received(3i)": date_received.day.to_s,
      "date_received(2i)": date_received.month.to_s,
      "date_received(1i)": date_received.year.to_s,
      correct: "true",
      saved: "true"
    }.with_indifferent_access
  end

  describe "validations" do
    describe "date_received" do
      it "must be a valid date" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = "31"
        attributes["date_received(2i)"] = "9"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end

      describe "day parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 31" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "32"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "twenty first"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "month parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 12" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "January"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year parameters" do
        it "must be a four digit year" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "24"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 2000" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 3000" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "Twenty twenty four"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      it "can be empty" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = ""
        attributes["date_received(2i)"] = ""
        attributes["date_received(1i)"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_valid
      end
    end
  end

  describe "not applicable" do
    it "can be no applicable" do
      attributes = valid_attributes
      attributes["not_applicable"] = "true"

      form.assign_attributes(attributes)
      form.save

      expect(project.tasks_data.reload.declaration_of_expenditure_certificate_not_applicable).to be true
    end
  end

  describe "status" do
    it "can be not started" do
      expect(form.status).to eql(:not_started)
    end

    it "can be in progress" do
      attributes = valid_attributes
      attributes["correct"] = "false"

      form.assign_attributes(attributes)
      form.save

      expect(form.status).to eql(:in_progress)
    end

    it "can be completed" do
      attributes = valid_attributes

      form.assign_attributes(attributes)
      form.save

      expect(form.status).to eql(:completed)
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "saves the task" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = "1"
        attributes["date_received(2i)"] = "1"
        attributes["date_received(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.valid?
        form.save

        expect(project.tasks_data.reload.declaration_of_expenditure_certificate_date_received).to eq(Date.new(2024, 1, 1))
      end
    end

    context "when the form is invalid" do
      it "shows a helpful error" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = "1"
        attributes["date_received(2i)"] = "Jan"
        attributes["date_received(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.valid?
        form.save

        expect(form.errors.messages_for(:date_received))
          .to include("Enter a valid date, like 1 1 2025")
      end
    end
  end
end
