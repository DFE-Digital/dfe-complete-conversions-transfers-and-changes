require "rails_helper"

RSpec.describe KeyContacts do
  before do
    mock_all_academies_api_responses
  end

  describe "associations" do
    it { is_expected.to belong_to(:project).required(true) }
    it { is_expected.to belong_to(:headteacher).optional(true) }
    it { is_expected.to belong_to(:chair_of_governors).optional(true) }
  end

  describe "headteacher" do
    it "can be a project contact" do
      contact = create(:project_contact)

      project = create(:conversion_project)
      key_contacts = described_class.create!(project: project, headteacher: contact)

      expect(key_contacts.headteacher).to be contact
    end

    it "can be an establishment contact" do
      contact = create(:establishment_contact)

      project = create(:conversion_project)
      key_contacts = described_class.create!(project: project, headteacher: contact)

      expect(key_contacts.headteacher).to be contact
    end
  end

  describe "chair of governors" do
    it "can be a project contact" do
      contact = create(:project_contact)

      project = create(:conversion_project)
      key_contacts = described_class.create!(project: project, chair_of_governors: contact)

      expect(key_contacts.chair_of_governors).to be contact
    end

    it "can be an establishment contact" do
      contact = create(:establishment_contact)

      project = create(:conversion_project)
      key_contacts = described_class.create!(project: project, chair_of_governors: contact)

      expect(key_contacts.chair_of_governors).to be contact
    end
  end
end
