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
end
