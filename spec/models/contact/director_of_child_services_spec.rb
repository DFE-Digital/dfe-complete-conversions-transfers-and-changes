require "rails_helper"

RSpec.describe Contact::DirectorOfChildServices, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:name).of_type :string }
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:phone).of_type :string }
    it { is_expected.to have_db_column(:organisation_name).of_type :string }
    it { is_expected.to have_db_column(:type).of_type :string }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:local_authority).optional }
  end

  describe "#organisation_name" do
    it "returns the organisation name" do
      local_authority = create(:local_authority, name: "Bumbletown Council")
      director = build(:director_of_child_services, local_authority: local_authority)
      expect(director.organisation_name).to eq(local_authority.name)
    end
  end

  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(LocalAuthorityPolicy)
    end
  end

  describe "#editable" do
    it "always returns false" do
      local_authority = create(:local_authority)
      director = build(:director_of_child_services, local_authority: local_authority)

      expect(director.editable?).to be false
    end
  end
end
