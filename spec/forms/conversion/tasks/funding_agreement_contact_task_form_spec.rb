require "rails_helper"

RSpec.describe Conversion::Task::FundingAgreementContactTaskForm do
  let(:user) { create(:user) }

  describe "validations" do
    let(:form) { valid_form }

    it "requires name" do
      form.name = nil
      expect(form).to be_invalid
    end

    it "requires title" do
      form.title = nil
      expect(form).to be_invalid
    end

    it "requires email" do
      form.email = nil
      expect(form).to be_invalid
    end

    it "validates the format of email" do
      form.email = "not.a.valid.email.com"
      expect(form).to be_invalid

      form.email = "a.valid@email.com"
      expect(form).to be_valid
    end
  end

  describe "#save" do
    before { mock_successful_api_response_to_create_any_project }

    let(:project) { create(:conversion_project) }

    it "sets funding_agreement_contact to true" do
      form = described_class.new(project.task_list, user)
      form.assign_attributes(valid_form.attributes)

      expect { form.save }.to change { Contact.count }.by(1)

      funding_agreement_contact = Contact.first

      expect(funding_agreement_contact.funding_agreement_contact?).to be true
    end
  end

  describe "the contact" do
    before { mock_successful_api_response_to_create_any_project }
    context "when there is no main contact for the project" do
      it "creates a new empty Contact" do
        project = create(:conversion_project)
        form = described_class.new(project.task_list, user)

        expect(form.name).to be_nil
        expect(form.email).to be_nil
      end
    end

    context "when there is main contact for the project" do
      it "loads the existing Contact" do
        project = create(:conversion_project)
        main_contact = create(:contact, funding_agreement_contact: true, project: project)
        form = described_class.new(project.task_list, user)

        expect(form.name).to eql main_contact.name
        expect(form.email).to eql main_contact.email
      end
    end
  end

  def valid_form
    tasks_data = Conversion::Voluntary::TaskList.new
    form = described_class.new(tasks_data, user)

    form.assign_attributes(
      name: "Jane Doe",
      title: "School manager",
      email: "jane.doe@school.sch.uk"
    )

    form
  end
end
