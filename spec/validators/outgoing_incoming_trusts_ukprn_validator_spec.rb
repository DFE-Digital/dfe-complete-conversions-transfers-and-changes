require "rails_helper"

RSpec.describe OutgoingIncomingTrustsUkprnValidator do
  subject { OutgoingIncomingTrustsUkprnValidatorTest.new }

  context "when the outgoing and incoming trust UKPRNs are different" do
    it "is valid" do
      subject.outgoing_trust_ukprn = 12345678
      subject.incoming_trust_ukprn = 87654321

      expect(subject).to be_valid
    end
  end

  context "when the outgoing and incoming trust UKPRNs are the same" do
    it "is invalid with errors" do
      subject.outgoing_trust_ukprn = 12345678
      subject.incoming_trust_ukprn = 12345678

      expect(subject).to be_invalid
      expect(subject.errors.count).to be 2
      expect(subject.errors.first.message).to include("cannot be the same")
    end
  end

  context "when the outgoing and incoming trust UKPRNs are not present" do
    it "is valid" do
      subject.outgoing_trust_ukprn = nil
      subject.incoming_trust_ukprn = nil

      expect(subject).to be_valid
    end
  end
end

class OutgoingIncomingTrustsUkprnValidatorTest
  include ActiveModel::Validations
  attr_accessor :outgoing_trust_ukprn
  attr_accessor :incoming_trust_ukprn

  validates_with OutgoingIncomingTrustsUkprnValidator
end
