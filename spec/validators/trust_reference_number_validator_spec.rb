require "rails_helper"

RSpec.describe TrustReferenceNumberValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :new_trust_reference_number
      validates :new_trust_reference_number, trust_reference_number: true
    }.new
  end

  context "with a valid TRN" do
    it "is valid" do
      subject.new_trust_reference_number = "TR01234"
      expect(subject.valid?).to be true
    end
  end

  context "with an invalid TRN" do
    it "is not valid" do
      subject.new_trust_reference_number = "012345"
      expect(subject.valid?).to be false
    end
  end
end
