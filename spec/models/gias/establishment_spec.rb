require "rails_helper"

RSpec.describe Gias::Establishment do
  describe "the basics" do
    it "can create instances" do
      establishment = create(:gias_establishment, urn: 123456, name: "A test establishment")

      expect(establishment.urn).to eql 123456
      expect(establishment.name).to eql "A test establishment"
    end
  end

  describe "database constraints" do
    it "ensures URN is unique" do
      create(:gias_establishment, urn: 123456)

      expect { create(:gias_establishment, urn: 123456) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:urn) }
  end
end
