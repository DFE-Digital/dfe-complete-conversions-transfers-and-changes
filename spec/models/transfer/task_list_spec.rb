require "rails_helper"

RSpec.describe Transfer::TaskList do
  let(:user) { create(:user) }

  describe ".identifiers" do
    it "returns all the identifiers for the tasks in the list" do
      transfer_task_list_identifiers = [
        :handover,
        :stakeholder_kick_off,
        :main_contact,
        :master_funding_agreement,
        :deed_of_novation_and_variation,
        :articles_of_association,
        :commercial_transfer_agreement,
        :deed_of_variation,
        :supplemental_funding_agreement,
        :land_consent_letter,
        :form_m,
        :church_supplemental_agreement,
        :deed_of_termination_for_the_master_funding_agreement,
        :deed_termination_church_agreement,
        :conditions_met,
        :rpa_policy
      ]

      expect(described_class.identifiers).to eql transfer_task_list_identifiers
    end
  end

  describe "#sections" do
    it "returns an array of the sections in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:transfer_project)
      task_list = described_class.new(project, user)

      expect(task_list.sections.count).to eql 3
    end
  end

  describe "#tasks" do
    it "returns an array of all the tasks in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:transfer_project)
      task_list = described_class.new(project, user)

      expect(task_list.tasks.count).to eql 16
      expect(task_list.tasks.first).to be_a Transfer::Task::HandoverTaskForm
      expect(task_list.tasks.last).to be_a Transfer::Task::RpaPolicyTaskForm
    end
  end
end
