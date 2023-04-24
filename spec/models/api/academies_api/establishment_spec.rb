require "rails_helper"

RSpec.describe Api::AcademiesApi::Establishment do
  describe "#local_authority" do
    let(:establishment) { build(:academies_api_establishment, local_authority_code: "300") }
    let!(:local_authority) { create(:local_authority, code: "300") }

    it "returns the local authority" do
      expect(establishment.local_authority).to eql(local_authority)
    end
  end
end
