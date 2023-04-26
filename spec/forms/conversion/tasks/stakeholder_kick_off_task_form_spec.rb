require "rails_helper"

RSpec.describe Conversion::Task::StakeholderKickOffTaskForm do
  let(:user) { create(:user) }

  describe "validations" do
    describe "date values" do
      context "when the month is invalid" do
        it "adds the appropriate error" do
          task_form = described_class.new(Conversion::Voluntary::TaskList.new, user)
          task_form.assign_attributes(
            "confirmed_conversion_date(2i)": "not a month",
            "confirmed_conversion_date(1i)": "2023"
          )

          expect(task_form).to be_invalid
          expect(task_form.errors.messages[:confirmed_conversion_date])
            .to include(I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.confirmed_conversion_date.errors.format"))
        end
      end

      context "when the year is invalid" do
        it "adds the appropriate error" do
          task_form = described_class.new(Conversion::Voluntary::TaskList.new, user)
          task_form.assign_attributes(
            "confirmed_conversion_date(2i)": "12",
            "confirmed_conversion_date(1i)": "not a year"
          )

          expect(task_form).to be_invalid
          expect(task_form.errors.messages[:confirmed_conversion_date])
            .to include(I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.confirmed_conversion_date.errors.format"))
        end
      end

      context "when the date is in the past" do
        it "is invalid with the appropriate error message" do
          task_form = described_class.new(Conversion::Voluntary::TaskList.new, user)
          task_form.assign_attributes(
            "confirmed_conversion_date(3i)": "1",
            "confirmed_conversion_date(2i)": "1",
            "confirmed_conversion_date(1i)": "2022"
          )

          expect(task_form).to be_invalid
          expect(task_form.errors.messages[:confirmed_conversion_date])
            .to include(I18n.t("conversion.task.stakeholder_kick_off.confirmed_conversion_date.errors.in_the_future"))
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
      task_form = described_class.new(Conversion::Voluntary::TaskList.new, user)

      expect(task_form.identifier).to eql :stakeholder_kick_off
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "updates the task list data" do
        mock_successful_api_response_to_create_any_project
        project = create(:conversion_project)
        task_data = project.task_list
        task_data.user = user
        task_form = described_class.new(task_data, user)
        task_form.introductory_emails = true

        task_form.save

        expect(task_data.stakeholder_kick_off_introductory_emails).to eql true
      end
    end

    context "when the form is invalid" do
      it "raises error" do
        mock_successful_api_response_to_create_any_project
        project = create(:conversion_project)
        task_data = project.task_list
        task_data.user = user
        task_form = described_class.new(task_data, user)
        allow(task_data).to receive(:valid?).and_return(false)

        expect { task_form.save }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#status" do
    context "when the task has no completed actions" do
      it "returns :not_started" do
        task_data = Conversion::Voluntary::TaskList.new
        task_form = described_class.new(task_data, user)

        expect(task_form.status).to eql :not_started
      end
    end

    context "when the task has some completed actions" do
      it "returns :in_progress" do
        task_data = Conversion::Voluntary::TaskList.new
        task_form = described_class.new(task_data, user)

        task_form.introductory_emails = true

        expect(task_form.status).to eql :in_progress
      end
    end

    context "when the task has all completed actions" do
      it "returns :completed" do
        task_data = Conversion::Voluntary::TaskList.new
        task_form = described_class.new(task_data, user)

        task_form.introductory_emails = true
        task_form.local_authority_proforma = true
        task_form.setup_meeting = true
        task_form.meeting = true
        task_form.check_provisional_conversion_date = true
        task_form.confirmed_conversion_date = Date.today

        expect(task_form.status).to eql :completed
      end
    end
  end

  describe "#locales_path" do
    it "returns the task path without 'TaskForm' as a dot list" do
      task_form = described_class.new(Conversion::Voluntary::TaskList.new, user)

      expect(task_form.locales_path).to eql "conversion.task.stakeholder_kick_off"
    end
  end
end
