require "rails_helper"

RSpec.describe Api::AcademiesApi::Establishment do
  let(:establishment) { build(:academies_api_establishment, local_authority_code: "300", establishment_number: "4567") }

  describe "#local_authority" do
    let!(:local_authority) { create(:local_authority, code: "300") }

    it "returns the local authority" do
      expect(establishment.local_authority).to eql(local_authority)
    end
  end

  describe "#dfe_number" do
    it "returns the combination of the local authority code and establishment number as the dfe number" do
      expect(establishment.dfe_number).to eql("300/4567")
    end
  end

  describe "#has_diocese?" do
    it "returns true when the diocese code is not 0000" do
      establishment = build(:academies_api_establishment, diocese_code: "CE26")
      expect(establishment.has_diocese?).to be true
    end

    it "returns false when the diocses code is 0000" do
      establishment = build(:academies_api_establishment, diocese_code: "0000")
      expect(establishment.has_diocese?).to be false
    end
  end

  describe "is_academy?" do
    it "returns true if the establishment has one of the 'academy like' codes" do
      establishment = build(:academies_api_establishment, type_code: 42)
      expect(establishment.is_academy?).to be true
    end

    it "returns false if the establishment does not have one of the 'academy like' codes" do
      establishment = build(:academies_api_establishment, type_code: 2)
      expect(establishment.is_academy?).to be false
    end
  end
end
