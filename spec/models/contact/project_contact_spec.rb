require "rails_helper"

RSpec.describe Contact::Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:name).of_type :string }
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:phone).of_type :string }
    it { is_expected.to have_db_column(:organisation_name).of_type :string }
    it { is_expected.to have_db_column(:type).of_type :string }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:project).optional }
  end

  describe "Validations" do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:title) }

    describe "#email" do
      it { is_expected.to allow_value("test@example.com").for(:email) }
      it { is_expected.to_not allow_value("notavalidemail").for(:email) }
    end
  end

  describe "scopes" do
    describe "by_name" do
      it "orders by name" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        project = create(:conversion_project)
        first_solicitor_contact = create(:project_contact, category: :solicitor, name: "B solicitor", project: project)
        second_solicitor_contact = create(:project_contact, category: :solicitor, name: "A solicitor", project: project)

        ordered_contacts = project.contacts.by_name

        expect(ordered_contacts.first).to eq second_solicitor_contact
        expect(ordered_contacts.last).to eq first_solicitor_contact
      end
    end
  end

  describe "#establishment_main_contact" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    it "returns true if the contact is the establishment_main_contact for its project" do
      project = create(:conversion_project)
      contact = create(:project_contact, project: project)
      project.establishment_main_contact_id = contact.id
      project.save

      expect(contact.reload.establishment_main_contact).to be true
    end

    it "returns false if the contact is NOT the establishment_main_contact for its project" do
      project = create(:conversion_project, establishment_main_contact_id: SecureRandom.uuid)
      contact = create(:project_contact, project: project)

      expect(contact.establishment_main_contact).to be false
    end

    it "returns false if the contact does not have a project" do
      contact = create(:project_contact, project_id: nil)
      expect(contact.establishment_main_contact).to be false
    end
  end
end
