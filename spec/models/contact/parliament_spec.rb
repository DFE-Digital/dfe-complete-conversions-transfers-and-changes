require "rails_helper"

RSpec.describe Contact::Parliament do
  describe "Columns" do
    it { is_expected.to have_db_column(:constituency_id).of_type :integer }
  end

  describe "#organisation_name" do
    it "returns the House of Commons" do
      expect(subject.organisation_name).to eq("House of Commons")
    end
  end

  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(ContactPolicy)
    end
  end

  describe "#editable" do
    it "always returns false" do
      expect(subject.editable?).to be false
    end
  end
end
