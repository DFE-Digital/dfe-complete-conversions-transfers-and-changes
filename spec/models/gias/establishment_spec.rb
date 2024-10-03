require "rails_helper"

RSpec.describe Gias::Establishment do
  describe "the basics" do
    it "can create instances" do
      establishment = build(:gias_establishment, urn: 123456, name: "A test establishment")

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

  describe "address" do
    it "returns the address as an array" do
      establishment = build(:gias_establishment, urn: 123456)
      expect(establishment.address).to eq(["Cator Lane", "Chilwell", "Beeston", "Nottingham", "Nottinghamshire", "NG9 4BB"])
    end
  end

  describe "phase" do
    it "returns the phase_name" do
      establishment = build(:gias_establishment, urn: 123456, phase_name: "secondary")
      expect(establishment.phase).to eq("secondary")
    end
  end

  describe "type" do
    it "returns the type_name" do
      establishment = build(:gias_establishment, urn: 123456, type_name: "Community school")
      expect(establishment.type).to eq("Community school")
    end
  end

  describe "status" do
    it "returns the status_name" do
      establishment = build(:gias_establishment, urn: 123456, status_name: "Closed")
      expect(establishment.status).to eq("Closed")
    end
  end

  describe "dfe_number" do
    it "returns the local authority code and establishment number, formatted as a dfe_number" do
      establishment = build(:gias_establishment, urn: 123456, local_authority_code: 123, establishment_number: 456)
      expect(establishment.dfe_number).to eq("123/456")
    end

    it "returns nil when the codes are missing" do
      establishment = build(:gias_establishment, urn: 123456, local_authority_code: nil, establishment_number: nil)
      expect(establishment.dfe_number).to be_nil
    end
  end

  describe "laestab" do
    it "returns the local authority code and establishment number, formatted as a dfe_number" do
      establishment = build(:gias_establishment, urn: 123456, local_authority_code: 123, establishment_number: 456)
      expect(establishment.laestab).to eq("123/456")
    end
  end

  describe "local_authority" do
    it "returns the local authority as per the local_authority_code" do
      establishment = build(:gias_establishment, urn: 123456, local_authority_code: 123)
      local_authority = create(:local_authority, code: 123)
      expect(establishment.local_authority).to eq(local_authority)
    end
  end

  describe "has_diocese?" do
    it "returns true if the establishment has a diocese_code" do
      establishment = build(:gias_establishment)
      expect(establishment.has_diocese?).to be true
    end

    it "returns false if the establishment has a diocese_code of 0000" do
      establishment = build(:gias_establishment, diocese_code: "0000")
      expect(establishment.has_diocese?).to be false
    end
  end

  describe "is_academy?" do
    it "returns true if the establishment has one of the 'academy like' codes" do
      establishment = build(:gias_establishment, type_code: "42")
      expect(establishment.is_academy?).to be true
    end

    it "returns false if the establishment does not have one of the 'academy like' codes" do
      establishment = build(:gias_establishment, type_code: "02")
      expect(establishment.is_academy?).to be false
    end
  end
end
