require "rails_helper"

RSpec.describe Conversion::TaskList do
  let(:user) { create(:user) }

  describe ".identifiers" do
    it "returns all the identifiers for the tasks in the list" do
      converison_task_list_identifiers = [
        :stakeholder_kick_off,
        :funding_agreement_contact,
        :articles_of_association,
        :redact_and_send
      ]

      expect(described_class.identifiers).to eql converison_task_list_identifiers
    end
  end

  describe ".layout" do
    it "returns the layout hash for the task list" do
      conversion_task_list_layout =
        [
          {
            identifier: :project_kick_off,
            tasks: [
              Conversion::Task::StakeholderKickOffTaskForm,
              Conversion::Task::FundingAgreementContactTaskForm
            ]
          },
          {
            identifier: :legal_documents,
            tasks: [
              Conversion::Task::ArticlesOfAssociationTaskForm
            ]
          },
          {
            identifier: :get_ready_for_opening,
            tasks: []
          },
          {
            identifier: :after_opening,
            tasks: [
              Conversion::Task::RedactAndSendTaskForm
            ]
          }
        ]
      expect(described_class.layout).to eql conversion_task_list_layout
    end
  end

  describe "#sections" do
    it "returns an array of the sections in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)
      task_list = described_class.new(project, user)

      expect(task_list.sections.count).to eql 4
    end
  end

  describe "#tasks" do
    it "returns an array of all the tasks in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)
      task_list = described_class.new(project, user)

      expect(task_list.tasks.count).to eql 4
      expect(task_list.tasks.first).to be_a Conversion::Task::StakeholderKickOffTaskForm
      expect(task_list.tasks.last).to be_a Conversion::Task::RedactAndSendTaskForm
    end
  end
end
