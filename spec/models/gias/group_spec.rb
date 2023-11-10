require "rails_helper"

RSpec.describe Gias::Group do
  describe "the basics" do
    it "can create instances" do
      establishment = create(:gias_group, ukprn: 12345678, original_name: "A test trust")

      expect(establishment.ukprn).to eql 12345678
      expect(establishment.original_name).to eql "A test trust"
    end
  end

  describe "database constraints" do
    it "ensures Unique Group Identifier is unique" do
      create(:gias_group, unique_group_identifier: 1234)

      expect { create(:gias_group, unique_group_identifier: 1234) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:unique_group_identifier) }
  end
end
