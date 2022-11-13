require "rails_helper"

RSpec.describe FirstDayOfMonthValidator do
  subject do
    Class.new {
      include ActiveModel::Validations
      attr_accessor :date
      validates :date, first_day_of_month: true
    }.new
  end

  context "when the date is on the first" do
    it "is valid" do
      subject.date = Date.new.at_beginning_of_month
      expect(subject).to be_valid
    end
  end

  context "when the date is not on the first" do
    it "is invalid" do
      subject.date = Date.new.at_end_of_month
      expect(subject).to be_invalid
    end
  end
end
