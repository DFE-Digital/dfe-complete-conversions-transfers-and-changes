require "rails_helper"

RSpec.describe UkprnValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :postcode
      validates :postcode, postcode: true
    }.new
  end

  context "with a valid postcode" do
    it "is valid" do
      subject.postcode = "N1C 4AG"
      expect(subject.valid?).to be true
    end
  end

  context "with an invalid postcode" do
    it "is invalid" do
      subject.postcode = "thisisnotavalidpostcode"
      expect(subject.valid?).to be false
    end
  end
end
