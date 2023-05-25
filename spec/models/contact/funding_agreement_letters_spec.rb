require "rails_helper"

RSpec.describe Contact::FundingAgreementLetters, type: :model do
  describe "Relationships" do
    it { is_expected.to belong_to(:project).optional }
  end

  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(ContactPolicy)
    end
  end
end
