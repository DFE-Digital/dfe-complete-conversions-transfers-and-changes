require "rails_helper"

RSpec.describe Conversion::Task::FundingAgreementContactTaskForm do
  let(:user) { create(:user) }

  describe "#save" do
    before { mock_successful_api_response_to_create_any_project }

    let(:project) { create(:conversion_project) }
    let(:contact) { create(:project_contact, project: project) }

    it "sets funding_agreement_contact_contact_id to the contact_id" do
      form = described_class.new(project.tasks_data, user)
      form.assign_attributes(valid_form.attributes)
      form.save

      funding_agreement_contact = Contact.first

      expect(project.tasks_data.funding_agreement_contact_contact_id).to eq(contact.id)
      expect(funding_agreement_contact.reload.type).to eq("Contact::FundingAgreementLetters")
    end
  end

  def valid_form
    tasks_data = Conversion::TasksData.new
    form = described_class.new(tasks_data, user)

    form.assign_attributes(contact_id: contact.id)

    form
  end
end
