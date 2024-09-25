require "rails_helper"

RSpec.describe TrustExistsValidator do
  subject do
    TestObjectForValidator.new
  end

  context "when the trust exists" do
    it "is valid" do
      mock_academies_api_trust_success(ukprn: 12345678)
      subject.ukprn_value = 12345678

      expect(subject).to be_valid
    end
  end

  context "when the trust does not exist" do
    it "is invalid and adds an error" do
      mock_academies_api_trust_not_found(ukprn: 12345678)
      subject.ukprn_value = 12345678

      expect(subject).to be_invalid
      expect(subject.errors.first.type).to eql :no_trust_found
    end
  end

  context "when the ukprn is a string" do
    it "casts to an integer and tries" do
      mock_academies_api_trust_success(ukprn: 12345678)
      subject.ukprn_value = "12345678"

      expect(subject).to be_valid
    end
  end
end

class TestObjectForValidator
  include ActiveModel::Validations
  attr_accessor :ukprn_value
  validates :ukprn_value, trust_exists: true
end
