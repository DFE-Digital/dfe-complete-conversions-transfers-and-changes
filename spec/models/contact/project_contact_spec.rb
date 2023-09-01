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

    describe "establishment_main_contact_for_school_only" do
      before do
        mock_successful_api_response_to_create_any_project
      end

      context "when the contact is not the establishment main contact" do
        it "returns true" do
          project = create(:conversion_project, establishment_main_contact: nil)
          contact = create(:project_contact, project: project)
          expect(contact.valid?).to be true
        end
      end

      context "when the contact category is a school contact" do
        it "returns true" do
          project = create(:conversion_project)
          contact = create(:project_contact, project: project, category: "school")
          project.update(establishment_main_contact_id: contact.id)
          expect(contact.valid?).to be true
        end
      end

      context "when the contact is the establishment main contact but the contact category is NOT school" do
        it "returns false" do
          project = create(:conversion_project)
          contact = create(:project_contact, project: project, category: "solicitor")
          project.update(establishment_main_contact_id: contact.id)
          expect(contact.valid?).to be false
        end
      end
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
end
