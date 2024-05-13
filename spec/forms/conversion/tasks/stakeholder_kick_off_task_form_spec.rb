require "rails_helper"

RSpec.describe Conversion::Task::StakeholderKickOffTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  before do
    mock_all_academies_api_responses
  end

  def valid_attributes
    confirmed_conversion_date = Date.today.at_beginning_of_month + 6.months
    {
      "confirmed_conversion_date(3i)": confirmed_conversion_date.day.to_s,
      "confirmed_conversion_date(2i)": confirmed_conversion_date.month.to_s,
      "confirmed_conversion_date(1i)": confirmed_conversion_date.year.to_s
    }.with_indifferent_access
  end

  describe "validations" do
    it "can be valid in this test" do
      attributes = valid_attributes

      form.assign_attributes(attributes)

      expect(form).to be_valid
    end

    describe "confirmed conversion date" do
      it "shows a helpful error message when invalid" do
        attributes = valid_attributes
        attributes["confirmed_conversion_date(1i)"] = "13"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
        expect(form.errors.messages_for(:confirmed_conversion_date)).to include(
          "Enter a valid month and year for the confirmed conversion date, like 9 2023"
        )
      end

      it "can be empty, but the day is always 1" do
        attributes = valid_attributes
        attributes["confirmed_conversion_date(3i)"] = "1"
        attributes["confirmed_conversion_date(2i)"] = ""
        attributes["confirmed_conversion_date(1i)"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_valid
      end

      describe "month params" do
        it "cannot be 0" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be less than 0" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be more than 12" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(2i)"] = "fourth"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year params" do
        it "must be four digits" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(1i)"] = "25"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be less than 2000" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be more than 3000" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(2i)"] = "twenty twenty five"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end
    end
  end

  describe ".identifier" do
    it "returns the class name without 'TaskForm' as a string" do
      expect(described_class.identifier).to eql "stakeholder_kick_off"
    end
  end

  describe "#identifier" do
    it "returns the class name without 'TaskForm' as a symbol" do
      form = described_class.new(Conversion::TasksData.new, user)

      expect(form.identifier).to eql :stakeholder_kick_off
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "updates the task list data" do
        form.introductory_emails = true

        form.save

        expect(project.tasks_data.stakeholder_kick_off_introductory_emails).to eql true
      end

      context "and the confirmed conversion date is submitted" do
        let(:project) { create(:conversion_project, conversion_date_provisional: true) }

        it "creates a new date history" do
          attributes = valid_attributes
          attributes["confirmed_conversion_date(1i)"] = "2025"
          attributes["confirmed_conversion_date(2i)"] = "1"

          form.assign_attributes(attributes)

          expect { form.save }.to change { SignificantDateHistory.count }.by(1)
          expect(project.reload.conversion_date_provisional?).to be false
        end
      end

      context "and the confirmed conversion date is not submitted" do
        let(:project) { create(:conversion_project, conversion_date_provisional: true) }

        it "does not create a new date history" do
          form.introductory_emails = true

          expect { form.save }.not_to change { SignificantDateHistory.count }
          expect(project.reload.conversion_date_provisional?).to be true
        end
      end

      context "and the conversion date is already confirmed" do
        let(:project) { create(:conversion_project, conversion_date_provisional: false) }

        it "does not create a new date history" do
          attributes = valid_attributes
          attributes["introductory_emails"] = "true"

          form.assign_attributes(attributes)

          expect { form.save }.not_to change { SignificantDateHistory.count }
          expect(project.reload.conversion_date_provisional?).to be false
        end
      end
    end

    context "when the form is invalid" do
      it "raises error" do
        project = create(:conversion_project)
        task_data = project.tasks_data
        form = described_class.new(task_data, user)
        allow(task_data).to receive(:valid?).and_return(false)

        expect { form.save }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#status" do
    let(:tasks_data) { project.tasks_data }

    context "when the task has no completed actions" do
      it "returns :not_started" do
        expect(form.status).to eql :not_started
      end
    end

    context "when the task has some completed actions" do
      it "returns :in_progress" do
        form.introductory_emails = true

        expect(form.status).to eql :in_progress
      end
    end

    context "when the tasks are all complete but the conversion date is not confirmed" do
      it "returns :in_progress" do
        form.introductory_emails = true
        form.local_authority_proforma = true
        form.setup_meeting = true
        form.meeting = true
        form.check_provisional_conversion_date = true

        expect(form.status).to eql :in_progress
      end
    end

    context "when only the conversion date is confirmed" do
      let(:project) { create(:conversion_project, conversion_date_provisional: false) }

      it "returns :in_progress" do
        expect(form.status).to eql :in_progress
      end
    end

    context "when the task has all completed actions and confirmed the conversion date" do
      let(:project) { create(:conversion_project, conversion_date_provisional: false) }

      it "returns :completed" do
        form.introductory_emails = true
        form.local_authority_proforma = true
        form.setup_meeting = true
        form.meeting = true
        form.check_provisional_conversion_date = true

        expect(form.status).to eql :completed
      end
    end
  end

  describe "#locales_path" do
    it "returns the task path without 'TaskForm' as a dot list" do
      form = described_class.new(Conversion::TasksData.new, user)

      expect(form.locales_path).to eql "conversion.task.stakeholder_kick_off"
    end
  end
end
