require "rails_helper"

RSpec.describe Conversion::Task::StakeholderKickOffTaskForm do
  let(:user) { create(:user) }

  describe "validations" do
    describe "date values" do
      context "when the month is invalid" do
        it "adds the appropriate error" do
          task_form = described_class.new(Conversion::TasksData.new, user)
          task_form.assign_attributes(
            "confirmed_conversion_date(2i)": "not a month",
            "confirmed_conversion_date(1i)": "2023"
          )

          expect(task_form).to be_invalid
          expect(task_form.errors.messages[:confirmed_conversion_date])
            .to include(I18n.t("conversion.task.stakeholder_kick_off.confirmed_conversion_date.errors.format"))
        end
      end

      context "when the year is invalid" do
        it "adds the appropriate error" do
          task_form = described_class.new(Conversion::TasksData.new, user)
          task_form.assign_attributes(
            "confirmed_conversion_date(2i)": "12",
            "confirmed_conversion_date(1i)": "not a year"
          )

          expect(task_form).to be_invalid
          expect(task_form.errors.messages[:confirmed_conversion_date])
            .to include(I18n.t("conversion.task.stakeholder_kick_off.confirmed_conversion_date.errors.format"))
        end
      end

      context "when the date is not provided" do
        it "is valid" do
          task_form = described_class.new(Conversion::TasksData.new, user)
          task_form.assign_attributes(
            "confirmed_conversion_date(3i)": "",
            "confirmed_conversion_date(2i)": "",
            "confirmed_conversion_date(1i)": ""
          )

          expect(task_form).to be_valid
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
      task_form = described_class.new(Conversion::TasksData.new, user)

      expect(task_form.identifier).to eql :stakeholder_kick_off
    end
  end

  describe "#save" do
    before { mock_successful_api_response_to_create_any_project }

    let(:project) { create(:conversion_project) }
    let(:tasks_data) { project.tasks_data }
    let(:task_form) { described_class.new(tasks_data, user) }

    context "when the form is valid" do
      it "updates the task list data" do
        task_form.introductory_emails = true

        task_form.save

        expect(tasks_data.stakeholder_kick_off_introductory_emails).to eql true
      end

      context "and the confirmed conversion date is submitted" do
        let(:project) { create(:conversion_project, conversion_date_provisional: true) }

        it "creates a new date history" do
          task_form.assign_attributes(
            "confirmed_conversion_date(2i)": "1",
            "confirmed_conversion_date(1i)": "2022"
          )

          expect { task_form.save }.to change { SignificantDateHistory.count }.by(1)
          expect(project.reload.conversion_date_provisional?).to be false
        end
      end

      context "and the confirmed conversion date is not submitted" do
        let(:project) { create(:conversion_project, conversion_date_provisional: true) }

        it "does not create a new date history" do
          task_form.introductory_emails = true

          expect { task_form.save }.not_to change { SignificantDateHistory.count }
          expect(project.reload.conversion_date_provisional?).to be true
        end
      end

      context "and the conversion date is already confirmed" do
        let(:project) { create(:conversion_project, conversion_date_provisional: false) }

        it "does not create a new date history" do
          task_form.introductory_emails = true
          task_form.assign_attributes(
            "confirmed_conversion_date(2i)": "1",
            "confirmed_conversion_date(1i)": "2022"
          )

          expect { task_form.save }.not_to change { SignificantDateHistory.count }
          expect(project.reload.conversion_date_provisional?).to be false
        end
      end
    end

    context "when the form is invalid" do
      it "raises error" do
        project = create(:conversion_project)
        task_data = project.tasks_data
        task_form = described_class.new(task_data, user)
        allow(task_data).to receive(:valid?).and_return(false)

        expect { task_form.save }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#status" do
    before { mock_successful_api_response_to_create_any_project }
    let(:project) { create(:conversion_project, conversion_date_provisional: true) }
    let(:tasks_data) { project.tasks_data }
    let(:task_form) { described_class.new(tasks_data, user) }

    context "when the task has no completed actions" do
      it "returns :not_started" do
        expect(task_form.status).to eql :not_started
      end
    end

    context "when the task has some completed actions" do
      it "returns :in_progress" do
        task_form.introductory_emails = true

        expect(task_form.status).to eql :in_progress
      end
    end

    context "when the tasks are all complete but the conversion date is not confirmed" do
      it "returns :in_progress" do
        task_form.introductory_emails = true
        task_form.local_authority_proforma = true
        task_form.setup_meeting = true
        task_form.meeting = true
        task_form.check_provisional_conversion_date = true

        expect(task_form.status).to eql :in_progress
      end
    end

    context "when only the conversion date is confirmed" do
      let(:project) { create(:conversion_project, conversion_date_provisional: false) }

      it "returns :in_progress" do
        expect(task_form.status).to eql :in_progress
      end
    end

    context "when the task has all completed actions and confirmed the converison date" do
      let(:project) { create(:conversion_project, conversion_date_provisional: false) }

      it "returns :completed" do
        task_form.introductory_emails = true
        task_form.local_authority_proforma = true
        task_form.setup_meeting = true
        task_form.meeting = true
        task_form.check_provisional_conversion_date = true

        expect(task_form.status).to eql :completed
      end
    end
  end

  describe "#locales_path" do
    it "returns the task path without 'TaskForm' as a dot list" do
      task_form = described_class.new(Conversion::TasksData.new, user)

      expect(task_form.locales_path).to eql "conversion.task.stakeholder_kick_off"
    end
  end
end
