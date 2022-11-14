require "rails_helper"

RSpec.describe UrnValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :urn_value
      validates :urn_value, urn: true
    }.new
  end

  context "with a valid URN" do
    it "is valid" do
      subject.urn_value = 123456
      expect(subject.valid?).to be true
    end
  end

  context "with a URN that is longer than six digits" do
    it "is invalid" do
      subject.urn_value = 1234567
      expect(subject.valid?).to be false
    end
  end

  context "with a URN that is shorter than six digits" do
    it "is invalid" do
      subject.urn_value = 12345
      expect(subject.valid?).to be false
    end
  end

  context "with a URN that contains letters" do
    it "is invalid" do
      subject.urn_value = "012LET"
      expect(subject.valid?).to be false
    end
  end
end
