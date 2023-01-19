require "rails_helper"

RSpec.describe Contact, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:name).of_type :string }
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:phone).of_type :string }
    it { is_expected.to have_db_column(:organisation_name).of_type :string }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:project) }
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
    describe "grouped_by_category" do
      it "groups and orders by category" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        project = create(:voluntary_conversion_project)
        first_solicitor_contact = create(:contact, category: :solicitor, name: "B solicitor", project: project)
        second_solicitor_contact = create(:contact, category: :solicitor, name: "A solicitor", project: project)
        _other_contact = create(:contact, category: :other, project: project)

        contacts = project.contacts.grouped_by_category
        groups = contacts.keys
        solicitor_group = contacts["solicitor"]

        expect(groups.first).to eql "solicitor"
        expect(groups.last).to eql "other"

        expect(solicitor_group.first).to eq second_solicitor_contact
        expect(solicitor_group.last).to eq first_solicitor_contact
      end
    end
  end
end
