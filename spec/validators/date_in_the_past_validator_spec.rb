require "rails_helper"

RSpec.describe DateInThePastValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :date
      validates :date, date_in_the_past: true
    }.new
  end

  context "when the date is in the past" do
    it "is valid" do
      subject.date = Date.today - 1.month
      expect(subject).to be_valid
    end
  end

  context "when the date is in the future" do
    it "is invalid" do
      subject.date = Date.today + 1.month
      expect(subject).to be_invalid
    end
  end

  context "when the date is today" do
    it "is valid" do
      subject.date = Date.today
      expect(subject).to be_valid
    end
  end

  context "when the date is in 2010" do
    it "is valid" do
      subject.date = Date.parse("2010-01-31")
      expect(subject).to be_valid
    end
  end

  context "when the date is before 2010" do
    it "is invalid" do
      subject.date = Date.parse("2009-12-31")
      expect(subject).to be_invalid
    end
  end
end
