require "rails_helper"

RSpec.describe Conversion::Task::FundingAgreementContactTaskForm do
  let(:user) { create(:user) }

  describe "#save" do
    before { mock_successful_api_response_to_create_any_project }

    let(:project) { create(:conversion_project) }
    let(:contact) { create(:project_contact, project: project) }

    it "sets funding_agreement_contact_contact_id to the contact_id" do
      form = described_class.new(project.tasks_data, user)
      form.assign_attributes(funding_agreement_contact_id: contact.id)
      form.save

      expect(project.funding_agreement_contact).to eq(contact)
    end
  end
end
