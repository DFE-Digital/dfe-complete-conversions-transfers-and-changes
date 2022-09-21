require "rails_helper"

RSpec.describe PastDateValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :date
      validates :date, past_date: true
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
    it "is invalid" do
      subject.date = Date.today
      expect(subject).to be_invalid
    end
  end
end
