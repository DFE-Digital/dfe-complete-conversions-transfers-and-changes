require "rails_helper"

class DummyClass
  include MultiparameterDate
end

RSpec.describe MultiparameterDate do
  subject = DummyClass.new

  describe "#date_from_multiparameter_hash" do
    it "creates a Date object from a hash" do
      date_hash = {3 => 1, 2 => 12, 1 => 2022}

      expect(subject.send(:date_from_multiparameter_hash, date_hash))
        .to eq Date.new(2022, 12, 1)
    end

    it "returns the hash when there is a argument error" do
      date_hash = {3 => 32, 2 => 12, 1 => 2022}

      expect(subject.send(:date_from_multiparameter_hash, date_hash))
        .to be date_hash
    end
  end

  describe "#date_parameter_valid?" do
    context "when the day is invalid" do
      it "returns false" do
        expect(subject.send(:date_parameter_valid?, {3 => 32, 2 => 12, 1 => 2022}))
          .to be false

        expect(subject.send(:date_parameter_valid?, {3 => 0, 2 => 12, 1 => 2022}))
          .to be false
      end
    end

    context "when the month is invalid" do
      it "returns false" do
        expect(subject.send(:date_parameter_valid?, {3 => 1, 2 => 24, 1 => 2022}))
          .to be false

        expect(subject.send(:date_parameter_valid?, {3 => 1, 2 => 0, 1 => 2022}))
          .to be false
      end
    end

    context "when the year is invalid" do
      it "returns false" do
        expect(subject.send(:date_parameter_valid?, {3 => 1, 2 => 12, 1 => 1945}))
          .to be false

        expect(subject.send(:date_parameter_valid?, {3 => 1, 2 => 12, 1 => 0}))
          .to be false
      end
    end

    context "when all values are valid" do
      it "returns true" do
        expect(subject.send(:date_parameter_valid?, {3 => 1, 2 => 12, 1 => 2022}))
          .to be true
      end
    end
  end

  describe "#day_for" do
    it "returns the day value at key 3" do
      date_hash = {3 => 1, 2 => 12, 1 => 2022}
      expect(subject.send(:day_for, date_hash)).to eq 1
    end
  end

  describe "#month_for" do
    it "returns the day value at key 2" do
      date_hash = {3 => 1, 2 => 12, 1 => 2022}
      expect(subject.send(:month_for, date_hash)).to eq 12
    end
  end

  describe "#year_for" do
    it "returns the day value at key 1" do
      date_hash = {3 => 1, 2 => 12, 1 => 2022}
      expect(subject.send(:year_for, date_hash)).to eq 2022
    end
  end
end
