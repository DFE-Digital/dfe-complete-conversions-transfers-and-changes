require "rails_helper"

RSpec.describe Conversion::Voluntary::Tasks::StakeholderKickOff do
  describe "validations" do
    it "is valid when both month and year are empty" do
      attributes = {"confirmed_conversion_date(2i)": "", "confirmed_conversion_date(1i)": ""}
      task = described_class.new(attributes)

      expect(task).to be_valid
    end

    it "validates for empty month or year" do
      attributes = {"confirmed_conversion_date(2i)": "", "confirmed_conversion_date(1i)": "2023"}
      task = described_class.new(attributes)

      expect(task).to be_invalid

      attributes = {"confirmed_conversion_date(2i)": "1", "confirmed_conversion_date(1i)": ""}
      task = described_class.new(attributes)

      expect(task).to be_invalid
    end

    it "validates the month is only a number between 1 and 12" do
      attributes = {"confirmed_conversion_date(2i)": "the 14th", "confirmed_conversion_date(1i)": "2023"}
      task = described_class.new(attributes)

      expect(task).to be_invalid

      attributes = {"confirmed_conversion_date(2i)": "0", "confirmed_conversion_date(1i)": "2023"}
      task = described_class.new(attributes)

      expect(task).to be_invalid

      attributes = {"confirmed_conversion_date(2i)": "13", "confirmed_conversion_date(1i)": "2023"}
      task = described_class.new(attributes)

      expect(task).to be_invalid
    end

    it "validates the year is only a number between 2000 and 2500" do
      attributes = {"confirmed_conversion_date(2i)": "1", "confirmed_conversion_date(1i)": "the year two thousand and twenty three"}
      task = described_class.new(attributes)

      expect(task).to be_invalid
      attributes = {"confirmed_conversion_date(2i)": "1", "confirmed_conversion_date(1i)": "100"}
      task = described_class.new(attributes)

      expect(task).to be_invalid

      attributes = {"confirmed_conversion_date(2i)": "1", "confirmed_conversion_date(1i)": "2501"}
      task = described_class.new(attributes)

      expect(task).to be_invalid
    end
  end
end
