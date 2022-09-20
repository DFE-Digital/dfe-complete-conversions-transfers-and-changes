require "rails_helper"

RSpec.describe UkprnValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :ukprn_value
      validates :ukprn_value, ukprn: true
    }.new
  end

  context "with a valid UKPRN" do
    it "is valid" do
      subject.ukprn_value = 12345678
      expect(subject.valid?).to be true
    end
  end

  context "with a UKPRN that is longer than eight digits" do
    it "is invalid" do
      subject.ukprn_value = 123456789
      expect(subject.valid?).to be false
    end
  end

  context "with a UKPRN that is shorter than eight digits" do
    it "is invalid" do
      subject.ukprn_value = 1234567
      expect(subject.valid?).to be false
    end
  end

  context "with a UKPRN that does not start with a 1" do
    it "is invalid" do
      subject.ukprn_value = 21234567
      expect(subject.valid?).to be false
    end
  end

  context "with a UKPRN that contains letters" do
    it "is invalid" do
      subject.ukprn_value = "012LET3434"
      expect(subject.valid?).to be false
    end
  end
end
