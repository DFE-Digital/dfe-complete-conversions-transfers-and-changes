require "rails_helper"

RSpec.describe GovukDateFieldParameters do
  it "is valid when the parameters are not present" do
    params = {}
    attribute_name = :test_date_attribute

    subject = described_class.new(attribute_name, params)

    expect(subject.valid?).to be true
    expect(subject.invalid?).to be false
  end

  it "is valid when the parameters are present and empty" do
    params = {
      "test_date_attribute(1i)" => "",
      "test_date_attribute(2i)" => "",
      "test_date_attribute(3i)" => ""
    }
    attribute_name = :test_date_attribute

    subject = described_class.new(attribute_name, params)

    expect(subject.valid?).to be true
    expect(subject.invalid?).to be false
  end

  it "is valid when the parameters are present and acceptable" do
    params = {
      "test_date_attribute(1i)" => "2024",
      "test_date_attribute(2i)" => "1",
      "test_date_attribute(3i)" => "1"
    }
    attribute_name = :test_date_attribute

    subject = described_class.new(attribute_name, params)

    expect(subject.valid?).to be true
    expect(subject.invalid?).to be false
  end

  it "is invalid when the date is not valid" do
    params = {
      "test_date_attribute(1i)" => "2024",
      "test_date_attribute(2i)" => "2",
      "test_date_attribute(3i)" => "30"
    }
    attribute_name = :test_date_attribute

    subject = described_class.new(attribute_name, params)

    expect(subject.valid?).to be false
    expect(subject.invalid?).to be true
  end

  describe "years range" do
    it "has a default 2000 to 3000" do
      params = {
        "test_date_attribute(1i)" => "3001",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "can be set to any range" do
      params = {
        "test_date_attribute(1i)" => "3001",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params, (2000..4000))

      expect(subject.valid?).to be true
      expect(subject.invalid?).to be false
    end
  end

  describe "year errors" do
    it "is invalid when the year is outside of the acceptable range" do
      params = {
        "test_date_attribute(1i)" => "3001",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the year is negative" do
      params = {
        "test_date_attribute(1i)" => "-2024",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the year is not a integer" do
      params = {
        "test_date_attribute(1i)" => "Twenty twenty four",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the year is zero" do
      params = {
        "test_date_attribute(1i)" => "0",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end
  end

  describe "month errors" do
    it "is invalid when the month is outside of the acceptable range" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "13",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the month is negative" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "-2",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the month is not a integer" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "January",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the month is zero" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "0",
        "test_date_attribute(3i)" => "1"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end
  end

  describe "day errors" do
    it "is invalid when the day is outside of the acceptable range" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "32"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the day is negative" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "-32"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the day is not a integer" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "first"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end

    it "is invalid when the day is zero" do
      params = {
        "test_date_attribute(1i)" => "2024",
        "test_date_attribute(2i)" => "1",
        "test_date_attribute(3i)" => "0"
      }
      attribute_name = :test_date_attribute

      subject = described_class.new(attribute_name, params)

      expect(subject.valid?).to be false
      expect(subject.invalid?).to be true
    end
  end
end
