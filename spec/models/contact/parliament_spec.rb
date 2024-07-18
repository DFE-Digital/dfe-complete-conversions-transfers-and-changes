require "rails_helper"

RSpec.describe Contact::Parliament do
  describe "Validations" do
    it { should validate_presence_of(:parliamentary_constituency) }
  end

  describe ".policy_class" do
    it "uses the ContactPolicy" do
      expect(described_class.policy_class).to eq(ContactPolicy)
    end
  end

  describe "#editable" do
    it "always returns false" do
      contact = described_class.new

      expect(contact.editable?).to be false
    end
  end

  describe "category" do
    it "returns member_of_parliament" do
      contact = described_class.new
      expect(contact.category).to eq("member_of_parliament")
    end
  end

  describe "title" do
    it "returns 'Member of Parliament for' in title case" do
      contact = described_class.new(parliamentary_constituency: "east ham")
      expect(contact.title).to eq("Member of Parliament for East Ham")
    end
  end

  describe "organisation_name" do
    it "returns HM Government" do
      contact = described_class.new
      expect(contact.organisation_name).to eq("HM Government")
    end
  end
end
