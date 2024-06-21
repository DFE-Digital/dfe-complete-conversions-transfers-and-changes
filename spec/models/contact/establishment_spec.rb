require "rails_helper"

RSpec.describe Contact::Establishment do
  describe "Validations" do
    it { should validate_presence_of(:establishment_urn) }
  end

  describe "#establishment" do
    it "returns the establishment by establishment_urn" do
      contact = described_class.new(establishment_urn: 123456)
      establishment = create(:gias_establishment, urn: 123456)

      expect(contact.establishment).to eq(establishment)
    end
  end

  describe ".policy_class" do
    it "uses the ContactPolicy" do
      expect(described_class.policy_class).to eq(ContactPolicy)
    end
  end

  describe "#editable" do
    it "always returns false" do
      contact = described_class.new(establishment_urn: 123456)

      expect(contact.editable?).to be false
    end
  end

  describe "category" do
    it "returns school_or_academy" do
      contact = described_class.new
      expect(contact.category).to eq("school_or_academy")
    end
  end
end
