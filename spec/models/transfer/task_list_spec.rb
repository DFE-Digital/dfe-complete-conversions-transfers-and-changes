require "rails_helper"

RSpec.describe Transfer::TaskList do
  let(:user) { create(:user) }

  describe ".identifiers" do
    it "returns all the identifiers for the tasks in the list" do
      transfer_task_list_identifiers = [
        :handover,
        :stakeholder_kick_off,
        :confirm_headteacher_contact,
        :main_contact,
        :request_new_urn_and_record,
        :sponsored_support_grant,
        :check_and_confirm_financial_information,
        :form_m,
        :land_consent_letter,
        :supplemental_funding_agreement,
        :deed_of_novation_and_variation,
        :church_supplemental_agreement,
        :master_funding_agreement,
        :articles_of_association,
        :deed_of_variation,
        :deed_of_termination_for_the_master_funding_agreement,
        :deed_termination_church_agreement,
        :commercial_transfer_agreement,
        :closure_or_transfer_declaration,
        :rpa_policy,
        :bank_details_changing,
        :confirm_incoming_trust_has_completed_all_actions,
        :conditions_met,
        :confirm_date_academy_transferred,
        :redact_and_send_documents,
        :declaration_of_expenditure_certificate
      ]

      expect(described_class.identifiers).to eql transfer_task_list_identifiers
    end
  end

  describe "#sections" do
    it "returns an array of the sections in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:transfer_project)
      task_list = described_class.new(project, user)

      expect(task_list.sections.count).to eql 4
    end
  end

  describe "#tasks" do
    it "returns an array of all the tasks in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:transfer_project)
      task_list = described_class.new(project, user)

      expect(task_list.tasks.count).to eql 26
      expect(task_list.tasks.first).to be_a Transfer::Task::HandoverTaskForm
      expect(task_list.tasks.last).to be_a Transfer::Task::DeclarationOfExpenditureCertificateTaskForm
    end
  end
end
